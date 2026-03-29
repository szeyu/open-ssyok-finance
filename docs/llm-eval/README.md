# llm-eval — ssyok Finance AI Quality Evaluation

Evaluates ssyok Finance's Gemini AI advisor using the **LLM-as-judge** technique (G-Eval inspired). Gemini 2.5 Pro acts as an impartial judge scoring Gemini 2.5 Flash responses on 4 dimensions.

## Setup

```bash
# From this directory
GEMINI_API_KEY=your_key_here uv run eval.py
```

## What It Does

- Runs 5 representative financial queries (EPF, PTPTN, budgeting, emergency fund, house deposit)
- Generates two responses per query:
  - **Generic baseline** — no Malaysian context
  - **ssyok Finance** — with full Malaysian system instruction
- Scores each response 1–5 on: Financial Accuracy, Malaysian Context, Actionability, Safety
- Prints a rich comparison table showing the improvement

## Dimensions

| Dimension | Description |
|-----------|-------------|
| Financial Accuracy | Is the advice factually correct? |
| Malaysian Context | Does it reference EPF/PTPTN/RM correctly? |
| Actionability | Does it give a concrete next step? |
| Safety | Does it avoid unregulated investment advice? |

## Models

| Role | Model |
|------|-------|
| Answer (evaluated) | `gemini-2.5-flash-preview-04-17` |
| Judge (evaluator) | `gemini-2.5-pro-preview-03-25` |
