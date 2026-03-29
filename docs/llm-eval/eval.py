"""
ssyok Finance — LLM Quality Evaluation
=======================================
Generates financial advice responses using Gemini 2.5 Flash (the product model),
then judges them with GPT-4o (cross-vendor judge = no self-serving bias).

Usage:
    uv run eval.py           # loads .env automatically

Dimensions evaluated (1–5 scale):
  - Financial Accuracy  : Is the advice factually correct?
  - Malaysian Context   : Does it reference EPF / PTPTN / RM correctly?
  - Actionability       : Does it give a concrete next step?
  - Safety              : Does it avoid unregulated investment advice?
"""

import os
import json
from pathlib import Path

from dotenv import load_dotenv
from google import genai
from google.genai import types as genai_types
from openai import OpenAI
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.text import Text
from rich import box

# ──────────────────────────────────────────────────────────────────────────────
# Load .env
# ──────────────────────────────────────────────────────────────────────────────

load_dotenv(Path(__file__).parent / ".env")

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "")

# ──────────────────────────────────────────────────────────────────────────────
# CONFIG
# ──────────────────────────────────────────────────────────────────────────────

# Model that generates the (evaluated) answers — ssyok Finance uses this
ANSWER_MODEL = "gemini-2.5-flash"

# Cross-vendor judge — GPT-5 has no stake in Gemini's performance
JUDGE_MODEL = "gpt-5"

# System instruction for the ssyok Finance AI advisor
SSYOK_SYSTEM_INSTRUCTION = """You are ssyok Finance's AI financial advisor — a virtual Certified Financial Planner (CFP) for young Malaysians.

Your role:
- Give personalized, actionable financial advice grounded in Malaysian context
- Always use RM (Ringgit Malaysia) for currency
- Reference Malaysian-specific products: EPF (Employees Provident Fund), PTPTN (student loan), ASB (Amanah Saham Bumiputera), KWSP, LHDN, and local bank products
- Speak in a warm, friendly tone — you can mix in Manglish naturally (e.g., "lah", "ah", "kan")
- For every answer, end with ONE concrete next action the user can take today
- Never recommend specific stocks or unregulated investments
- Always clarify if something requires consultation with a licensed financial planner

Current context: The user is a young Malaysian professional tracking their finances with ssyok Finance."""

# Generic system instruction (baseline — no Malaysian context)
GENERIC_SYSTEM_INSTRUCTION = """You are a helpful financial advisor. Give accurate and helpful financial advice."""

# 5 representative user queries covering the core use cases
TEST_PROMPTS = [
    {
        "id": "Q1",
        "label": "EPF Contribution",
        "prompt": "How much should I contribute to EPF beyond the mandatory 11%? I earn RM 3,500/month.",
    },
    {
        "id": "Q2",
        "label": "PTPTN vs Invest",
        "prompt": "Should I pay off my PTPTN loan early or invest the money in ASB instead?",
    },
    {
        "id": "Q3",
        "label": "Budget Advice",
        "prompt": "I earn RM 3,000 and spend RM 2,700 every month. What should I do first?",
    },
    {
        "id": "Q4",
        "label": "Emergency Fund",
        "prompt": "How do I build a 6-month emergency fund? Where should I park it?",
    },
    {
        "id": "Q5",
        "label": "House Deposit",
        "prompt": "I want to buy a house worth RM 450,000 in 5 years. How do I plan for the down payment?",
    },
]

JUDGE_SYSTEM = "You are a strict, impartial evaluator of AI financial advisor responses. You only return valid JSON."

JUDGE_PROMPT_TEMPLATE = """Evaluate this AI financial advisor response for young Malaysians.

Score on 4 dimensions (integer 1–5 each):

1. **financial_accuracy**: Is the advice factually correct and numerically sound?
   1=Incorrect/dangerous, 3=Broadly correct but vague, 5=Precise and well-reasoned

2. **malaysian_context**: Does it reference local products (EPF, PTPTN, ASB, RM, LHDN)?
   1=No Malaysian context (e.g. mentions 401k/USD), 3=Mentions RM only, 5=Expertly uses EPF/PTPTN/ASB

3. **actionability**: Does it give a concrete, specific next step?
   1=No action, 3=Vague suggestion ("save more"), 5=Specific + measurable (e.g. "Set up RM 300/month standing order to ASB")

4. **safety**: Does it avoid unregulated investment tips and stay within responsible guidance?
   1=Dangerous/unregulated, 3=Safe but too vague to be useful, 5=Safe and still fully actionable

---
User Question: {prompt}

AI Response: {response}
---

Return ONLY valid JSON, no markdown, no explanation:
{{"financial_accuracy":<int>,"malaysian_context":<int>,"actionability":<int>,"safety":<int>,"reasoning":"<one sentence on the weakest dimension>"}}"""


# ──────────────────────────────────────────────────────────────────────────────
# HELPERS
# ──────────────────────────────────────────────────────────────────────────────

def get_gemini_response(client: genai.Client, system_instruction: str, user_prompt: str) -> str:
    """Generate a response from Gemini with a given system instruction."""
    response = client.models.generate_content(
        model=ANSWER_MODEL,
        contents=user_prompt,
        config=genai_types.GenerateContentConfig(
            system_instruction=system_instruction,
            temperature=0.3,
            max_output_tokens=2048,
        ),
    )
    return response.text.strip()


def judge_with_gpt(openai_client: OpenAI, prompt: str, response: str) -> dict:
    """Use GPT-5 to score a Gemini response on 4 dimensions. Returns a dict."""
    result = openai_client.chat.completions.create(
        model=JUDGE_MODEL,
        messages=[
            {"role": "system", "content": JUDGE_SYSTEM},
            {"role": "user", "content": JUDGE_PROMPT_TEMPLATE.format(
                prompt=prompt, response=response
            )},
        ],
    )
    raw = result.choices[0].message.content or ""
    # Strip markdown fences if present
    if "```" in raw:
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]
    raw = raw.strip()
    # Fallback: extract the first {...} block via simple scan
    if not raw.startswith("{"):
        start = raw.find("{")
        end = raw.rfind("}") + 1
        if start != -1 and end > start:
            raw = raw[start:end]
    return json.loads(raw)


def score_color(score: int) -> str:
    if score >= 5:   return "bold green"
    elif score >= 4: return "green"
    elif score >= 3: return "yellow"
    else:            return "red"


def avg(scores: list) -> float:
    return sum(scores) / len(scores) if scores else 0.0


# ──────────────────────────────────────────────────────────────────────────────
# MAIN
# ──────────────────────────────────────────────────────────────────────────────

def main():
    console = Console()

    if not GEMINI_API_KEY:
        console.print("[bold red]Error:[/] GEMINI_API_KEY not found in .env")
        raise SystemExit(1)
    if not OPENAI_API_KEY:
        console.print("[bold red]Error:[/] OPENAI_API_KEY not found in .env")
        raise SystemExit(1)

    gemini_client = genai.Client(api_key=GEMINI_API_KEY)
    openai_client = OpenAI(api_key=OPENAI_API_KEY)

    console.print(Panel.fit(
        f"[bold]Answer model :[/] [cyan]{ANSWER_MODEL}[/] (Gemini — the product)\n"
        f"[bold]Judge model  :[/] [cyan]{JUDGE_MODEL}[/] (OpenAI — cross-vendor, no bias)\n"
        f"[bold]Test prompts :[/] [cyan]{len(TEST_PROMPTS)}[/]\n"
        f"[bold]Dimensions   :[/] [cyan]Financial Accuracy · Malaysian Context · Actionability · Safety[/]",
        title="[bold green]ssyok Finance — LLM-as-Judge Eval[/]",
        border_style="green",
    ))

    results = []

    for item in TEST_PROMPTS:
        console.print(f"\n[bold blue]→ [{item['id']}] {item['label']}[/]")

        console.print("  Generating [yellow]generic[/] response (Gemini)...", end="")
        generic_resp = get_gemini_response(gemini_client, GENERIC_SYSTEM_INSTRUCTION, item["prompt"])
        console.print(" ✓")

        console.print("  Generating [green]ssyok[/] response (Gemini + MY context)...", end="")
        ssyok_resp = get_gemini_response(gemini_client, SSYOK_SYSTEM_INSTRUCTION, item["prompt"])
        console.print(" ✓")

        console.print(f"  Judging with [magenta]GPT-5[/]...", end="")
        generic_scores = judge_with_gpt(openai_client, item["prompt"], generic_resp)
        ssyok_scores = judge_with_gpt(openai_client, item["prompt"], ssyok_resp)
        console.print(" ✓")

        results.append({
            "item": item,
            "generic": generic_scores,
            "ssyok": ssyok_scores,
        })

    # ── Main comparison table ─────────────────────────────────────────────────
    DIMS = [
        ("financial_accuracy", "Fin. Accuracy"),
        ("malaysian_context",  "MY Context"),
        ("actionability",      "Actionability"),
        ("safety",             "Safety"),
    ]

    console.print()
    table = Table(
        title="[bold]ssyok Finance vs Generic — GPT-5 Judge Scores (1–5)[/]",
        box=box.ROUNDED,
        border_style="green",
        show_lines=True,
        header_style="bold white on dark_green",
    )
    table.add_column("Prompt", style="bold", min_width=16)
    for _, label in DIMS:
        table.add_column(f"Generic\n{label}", justify="center", min_width=10)
    for _, label in DIMS:
        table.add_column(f"ssyok+\n{label}", justify="center", min_width=10)
    table.add_column("Δ Avg", justify="center", min_width=7)

    all_g_avgs, all_s_avgs = [], []

    for r in results:
        g, s = r["generic"], r["ssyok"]
        g_scores = [g.get(d, 0) for d, _ in DIMS]
        s_scores = [s.get(d, 0) for d, _ in DIMS]
        g_avg = avg(g_scores)
        s_avg = avg(s_scores)
        delta = s_avg - g_avg
        all_g_avgs.append(g_avg)
        all_s_avgs.append(s_avg)

        row = [r["item"]["label"]]
        for sc in g_scores:
            row.append(Text(str(sc), style=score_color(sc), justify="center"))
        for sc in s_scores:
            row.append(Text(str(sc), style=score_color(sc), justify="center"))
        d_str = f"+{delta:.1f}" if delta > 0 else f"{delta:.1f}"
        row.append(Text(d_str, style="bold green" if delta > 0 else "bold red", justify="center"))
        table.add_row(*row)

    # Overall averages row
    g_overall = avg(all_g_avgs)
    s_overall = avg(all_s_avgs)
    overall_delta = s_overall - g_overall
    d_str = f"+{overall_delta:.2f}" if overall_delta > 0 else f"{overall_delta:.2f}"
    table.add_section()
    table.add_row(
        "[bold]OVERALL AVG[/]",
        *[Text(f"{avg([r['generic'].get(d,0) for r in results]):.2f}", style="white", justify="center") for d, _ in DIMS],
        *[Text(f"{avg([r['ssyok'].get(d,0) for r in results]):.2f}", style="bold green", justify="center") for d, _ in DIMS],
        Text(d_str, style="bold green" if overall_delta > 0 else "bold red", justify="center"),
    )
    console.print(table)

    # ── Per-dimension table ───────────────────────────────────────────────────
    dim_table = Table(
        title="[bold]Per-Dimension Summary[/]",
        box=box.SIMPLE_HEAD,
        border_style="dim",
        header_style="bold",
    )
    dim_table.add_column("Dimension", style="bold", min_width=18)
    dim_table.add_column("Generic Avg", justify="center")
    dim_table.add_column("ssyok+ Avg", justify="center")
    dim_table.add_column("Improvement", justify="center")
    dim_table.add_column("% Better", justify="center")

    for dim_key, dim_label in DIMS:
        g_dim = [r["generic"].get(dim_key, 0) for r in results]
        s_dim = [r["ssyok"].get(dim_key, 0) for r in results]
        g_avg_d = avg(g_dim)
        s_avg_d = avg(s_dim)
        delta = s_avg_d - g_avg_d
        pct = (delta / g_avg_d * 100) if g_avg_d > 0 else 0
        d_str = f"+{delta:.2f}" if delta > 0 else f"{delta:.2f}"
        pct_str = f"+{pct:.0f}%" if pct > 0 else f"{pct:.0f}%"
        dim_table.add_row(
            dim_label,
            Text(f"{g_avg_d:.2f}", style=score_color(round(g_avg_d)), justify="center"),
            Text(f"{s_avg_d:.2f}", style=score_color(round(s_avg_d)), justify="center"),
            Text(d_str, style="bold green" if delta > 0 else "bold red", justify="center"),
            Text(pct_str, style="bold green" if pct > 0 else "bold red", justify="center"),
        )
    console.print(dim_table)

    # ── Summary panel ─────────────────────────────────────────────────────────
    improvement_pct = (overall_delta / g_overall * 100) if g_overall > 0 else 0
    console.print(Panel(
        f"[bold]Generic baseline :[/]  [yellow]{g_overall:.2f} / 5[/]\n"
        f"[bold]ssyok Finance    :[/]  [bold green]{s_overall:.2f} / 5[/]\n"
        f"[bold]Improvement      :[/]  [bold green]+{overall_delta:.2f} pts  ({improvement_pct:.1f}% better)[/]\n\n"
        f"[dim]Answer: {ANSWER_MODEL} | Judge: {JUDGE_MODEL} (cross-vendor) | Method: LLM-as-judge (G-Eval inspired)[/]",
        title="[bold green]Overall Summary[/]",
        border_style="green",
    ))

    # ── Judge reasoning notes ─────────────────────────────────────────────────
    console.print("\n[bold]GPT-5 judge notes (weakest dimension per ssyok response):[/]")
    for r in results:
        note = r["ssyok"].get("reasoning", "—")
        console.print(f"  [cyan]{r['item']['id']} {r['item']['label']}:[/] {note}")


if __name__ == "__main__":
    main()
