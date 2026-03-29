# ssyok Finance — KitaHack 2026 Pitch Script
**Presenter**: Sim Sze Yu (CEO) | **Duration**: ~5 minutes | **Format**: Demo Day Pitch

---

## Slide 1 — Title (~10s)
> *Open with energy and a smile. Make eye contact.*

"Hi everyone, I'm Sze Yu, and this is **ssyok Finance** — your hyper-local AI financial companion, built for Malaysia, by Malaysians.

Let's talk about why this matters."

---

## Slide 2 — SDG 8.10 (~15s)
> *Build the foundation. Speak slowly on the quote.*

"Our mission is rooted in **UN Sustainable Development Goal 8, Target 8.10** — to strengthen access to banking, insurance, and financial services *for all*.

But here's the key insight: **access isn't the problem anymore. Understanding is.**"

---

## Slide 3 — The Grim Reality (~30s)
> *Pause 1 second after each stat. Let the numbers land.*

"Let me show you the data.

**89% of Malaysians** already have a bank account — World Bank Global Findex 2024. So access? Solved.

But Malaysia's financial literacy score is just **59.1 out of 100** — that's the MYFLIC Index from BNM's FCI Survey 2024. A failing grade.

The result? **53,000 youths** under 30 are already trapped in debt, owing a combined **RM 1.9 billion** — AKPK, October 2024.

We gave people bank accounts but never taught them how to use them. That's the gap we're closing."

---

## Slide 4 — The Gap (~20s)
> *Be direct. Name competitors, then pivot to our positioning.*

"So where are the solutions?

Generic finance apps — **too boring, no Malaysian context.** Bank apps — **too corporate, they're selling you products, not educating you.**

And the only youth-friendly fintech in Malaysia — Raiz — **exited the market** in September 2024, leaving users stranded.

**That gap? That's exactly where ssyok Finance sits.**"

---

## Slide 5 — The Spark (~25s)
> *This is the emotional hook. Show the real screenshots. Smile when you say "but what if there's an app for that?"*

"This isn't a hypothetical problem. Let me show you a **real conversation**.

I asked my friend Khai Shen: *'How much you spend a month ah? In KL.'* He showed me his finance planner — a **Google Spreadsheet** tracking income, rent, food, transport, savings, everything.

I said: *'I wanna do the spreadsheet also.'* But then I thought — **what if there's an app that does all of this for you? With AI?**

That's how ssyok Finance was born."

---

## Slide 6 — First Principles (~20s)
> *Pause before the punchline. Let the contrast land. This reframes the entire product.*

"Before we built anything, we asked one question from first principles: **What is the first principle of growing wealth?**

Most apps assume it's tracking — know where your money went. But tracking is **reactive**. It looks backward.

The real first principle is **planning** — know where your money *should* go. That's **proactive**. It looks forward.

That one insight shaped everything we built. **ssyok Finance is not a finance tracker. It's a financial planner.**"

---

## Slide 7 — Solution (~30s)
> *This is the 'aha' moment. Slow down on the Personal Inflation Rate.*

"ssyok Finance is your **Virtual Certified Financial Planner** — powered by Gemini AI.

A real CFP costs RM 300 to RM 600 per hour. We provide the same quality guidance — **for free**.

But our real differentiator is **Personal Inflation Rate**.

A generic advisor says 'plan for 3% inflation.' But if you spend 40% of your income on medical bills, your *actual* inflation could be 6%. ssyok Finance calculates **your** inflation based on **your** spending — so every plan is grounded in reality, not national averages."

---

## Slide 8 — App Demo (~40s)
> *Walk through each screen. Point at specific UI elements. Don't rush the AI chat quote.*

"Let me walk you through the working app.

**Dashboard** — at a glance you see your net worth, emergency fund progress, and total assets. Every metric has a 'Chat about this' button that opens a conversation with Gemini — instant context-aware advice.

**Goals** — set a savings target, and ssyok calculates the exact monthly amount needed, tracks your progress in real-time, and warns you if you're falling behind.

**AI Chat** — this is the core. Ask Gemini anything — 'How do I reach my house deposit faster?' — and it responds in Manglish:

*'Your Food & Dining is 35% of income — cut by RM 200 a month and you'll hit your House goal 8 months faster.'*

**That's not just tracking. That's a financial advisor in your pocket.**"

---

## Slide 9 — Tech Stack (~30s)
> *Show confidence. Emphasize 'Gemini-native' and the architecture decisions.*

"Our entire stack is **100% Google**.

Flutter for cross-platform UI. Firebase Auth, Firestore for real-time data. Cloud Functions as our serverless backend in **asia-southeast1** — Singapore — for the lowest latency to Malaysian users.

And at the core: **Google ADK orchestrating Gemini 2.5 Flash**.

One key technical challenge we solved: **prompt engineering with Malaysian context**. We built prompt templates that inject EPF benchmarks, PTPTN references, and RM-denominated advice — so every Gemini response is culturally relevant.

**This is not a Gemini wrapper. This is a Gemini-native product.**"

---

## Slide 9.5 — AI Quality Evaluation (~25s)
> *This is where you demonstrate rigor. Speak slowly on the methodology steps.*

"But we didn't just ship the AI and hope for the best. We **evaluated it**.

Using **LLM-as-judge** — an industry-standard technique — we had **GPT-5** score our advisor's responses against a generic LLM baseline. Cross-vendor judge: zero self-serving bias.

5 test prompts. 4 dimensions each: Financial Accuracy, Malaysian Context, Actionability, Safety.

The biggest gap? **Malaysian Context — 3.40 for generic, 4.60 for ssyok. That's a 35% improvement.** A generic LLM doesn't know what EPF is. Ours does.

Both models scored 4.80 on Safety — our AI gives responsible advice. The eval script is open source at `docs/llm-eval/eval.py`."

---

## Slide 10 — User Feedback & Iteration (~25s)
> *Real users = real points. Lead with the numbers, then tell the iteration story.*

"We tested with **6 real users** across 6 different Android devices. Zero crashes reported. Onboarding clarity rated **4.2 out of 5**.

Here's what the data showed: **5 out of 6** users loved the Dashboard and Net Worth Graph — that validated our core design decision. Calculators came in second at 4 out of 6.

The number one feature request? **Monthly cash flow and budgeting** — directly added to our Q3 2026 roadmap. Personalisation features — now planned for v2 AI persona.

One user said: *'Amazing and structured app for beginners and professionals.'*

**Real users. Real data. Real iteration.**"

---

## Slide 11 — Business Model & Future Roadmap (~25s)
> *Quick on the model, then paint the future vision with concrete milestones.*

"Our model is **Friendly Freemium**.

Free tier — ad-supported via Google AdMob — gives everyone the core tools and 5 Gemini chats per month. **ssyok+ AI** at RM 4.90 per month unlocks 100 AI responses, smart audits, and automated debt strategies.

**Beyond the hackathon**, our roadmap is clear: by Q3 2026 we launch on Google Play with monthly budgeting. Q4, we integrate open banking APIs. By 2027, we add insurance comparison and EPF optimization — scaling from a financial companion into a **full financial platform for Southeast Asia**.

This isn't just a prototype. It's a product with a path."

---

## Slide 12 — GTM & Impact (~20s)
> *Connect SDG alignment to concrete impact metrics.*

"We reach Gen Z where they are — **universities, TikTok, campus ambassadors.**

Year 1 target: **100,000 users**, starting with fresh graduates who have **zero access** to professional financial advice.

Every user we onboard directly advances SDG 8.10 — free access to financial guidance, savings tools, insurance tracking, and AI-powered education — **for all, not just those who can afford a financial planner.**"

---

## Slide 13 — Team & Ask (~15s)
> *End with energy and a smile. The team card is memorable — own it.*

"We're **Team Hokkien Mee is Red**.

I'm the CEO and lead engineer. My CTO is **Claude**, and my AI Product Lead is **Gemini** — yes, the AI was built with AI.

Our ask is simple:

**Help us help Malaysia save — one ringgit at a time.**

Thank you."

---

## Timing Summary

| Slide | Topic | Time |
|-------|-------|------|
| 1 | Title | ~10s |
| 2 | SDG 8.10 | ~15s |
| 3 | Grim Reality | ~30s |
| 4 | The Gap | ~20s |
| 5 | The Spark | ~25s |
| 6 | First Principles | ~20s |
| 7 | Solution | ~30s |
| 8 | Demo | ~40s |
| 9 | Tech Stack | ~25s |
| 9.5 | AI Evaluation | ~25s |
| 10 | User Feedback | ~25s |
| 11 | Business Model & Roadmap | ~25s |
| 12 | GTM & Impact | ~20s |
| 13 | Team & Ask | ~15s |
| **Total** | | **~5m 10s** |

> Buffer of ~15s for pauses, transitions, and audience reactions.

---

## Delivery Tips

- **Slide 3** — Pause 1 full second after each stat. Let the numbers sink in. The contrast between 89% access and 59.1/100 literacy is your strongest rhetorical moment.
- **Slide 5** — This is your emotional hook. Let the screenshots speak — point at the chat, then the spreadsheet. Smile when you say "what if there's an app for that?" The judges will relate.
- **Slide 6** — This is your intellectual anchor. Pause before "planning." The contrast between tracking (reactive) and planning (proactive) reframes your entire product. Judges will remember this framing.
- **Slide 7** — Slow down on "your inflation is 5.1%." This is the key differentiator. If judges remember one thing, make it this.
- **Slide 8** — This is your demo. Walk slowly through each screenshot. Read the Manglish quote with personality — it shows cultural fit.
- **Slide 9** — Say "Gemini-native product" with conviction. Mention "asia-southeast1" to show you thought about latency — judges notice infrastructure decisions.
- **Slide 10** — The user feedback is worth 10 points. Mention the *quote* (shows quality) and the *iteration* (shows you listened and improved this version based on that feedback).
- **Slide 11** — The roadmap is worth 10 points. Hit Q3, Q4, 2027 — concrete timeline shows you're serious about post-hackathon development.
- **Slide 13** — Smile when you say "Claude is my CTO." It's memorable and shows personality. End on "one ringgit at a time" — clean, memorable close.

## Criteria Coverage Checklist

| # | Criteria | Points | Covered In |
|---|----------|--------|------------|
| 1 | Challenge Alignment (SDG) | 10 | Slide 2 + Slide 12 |
| 2 | Problem Definition | 10 | Slide 3 + Slide 5 |
| 3 | Relevance to Target Users | 10 | Slide 3 + Slide 5 + Slide 10 (6 devices, n=6 data) |
| 4 | Effectiveness of Solution | 10 | Slide 6 (First Principles) + Slide 7 + Slide 8 |
| 5 | Future Development | 10 | Slide 11 (roadmap) |
| 6 | Innovation & Creativity | 10 | Slide 6 (First Principles) + Slide 7 (Personal Inflation) + Slide 9 |
| 7 | User Testing & Iteration | 10 | Slide 10 (quantified: 6 testers, 4.2/5, 0 crashes, feature bars, iteration table) |
| 8 | Technical Completeness | 15 | Slide 8 (demo) + Slide 9 |
| 9 | Use of Google Technologies | 15 | Slide 9 + **Slide 9.5 (LLM eval, metrics, 4.7/5 avg, +43%)** |
| 10 | Technical Demonstration | 15 | Slide 8 + Slide 9 (why-these-choices rationale) |
| 11 | Scalability & Sustainability | 15 | Slide 9 (serverless + asia-southeast1 + Firestore rationale) + Slide 11 |
| | **Total** | **130** | **All covered — Criteria 7, 9, 10 now Excellent-level** |
