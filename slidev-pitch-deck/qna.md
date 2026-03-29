# ssyok Finance — Judge Q&A Prep Sheet
**KitaHack 2026 Demo Day** | **March 29, 2026**

> Organized by category. For each question: the likely intent behind it, your best answer, and a fallback if pushed further.

---

## 1. Technical — AI & Gemini

### Q: "Why Gemini and not GPT or Claude?"
**Intent:** Are you just using Google tech because it's required, or is there a real reason?

**Answer:**
"Three reasons. First, Gemini 2.5 Flash gives us the best latency-to-quality ratio — critical for a chat experience. Second, Google ADK lets us orchestrate the agent with built-in session management and streaming — we get SSE streaming responses out of the box without building our own chunking pipeline. Third, our entire stack is Firebase — Auth, Firestore, Cloud Functions — so staying in the Google ecosystem means zero credential translation, native secret management, and one billing account. It's not just compliance, it's the right architectural choice."

**If pushed:** "We evaluated alternatives during design. GPT-4 has higher latency from Southeast Asia, and Claude doesn't have an equivalent to ADK for agent orchestration. Gemini Flash is also the most cost-effective for our freemium model."

---

### Q: "How does the AI actually work? Is it just a wrapper around Gemini?"
**Intent:** Is there real engineering, or did you just call the API?

**Answer:**
"Definitely not a wrapper. Our Cloud Function receives the user's financial profile — assets, debts, goals, spending categories — and injects it into a structured prompt with Malaysian financial context: EPF benchmarks, PTPTN rates, ASB references, RM-denominated advice. We use Google ADK's `LlmAgent` with a detailed system instruction, and conversation history is replayed as formatted context in each request since Cloud Functions are stateless. The response is streamed via Server-Sent Events so users see tokens arrive in real-time. The prompt engineering is the real IP — that's what makes it feel like a Malaysian CFP, not a generic chatbot."

**If pushed:** "We can show you the agent code. The system instruction alone is 25+ lines of Malaysian financial context — EPF, ASB, PTPTN, Tabung Haji, PRS, unit trusts, REITs on Bursa. Every response ends with a concrete next step the user can take today."

---

### Q: "What is Personal Inflation Rate? How do you calculate it?"
**Intent:** Is this a real feature or just a buzzword?

**Answer:**
"National CPI says inflation is 2-3%, but that's an average across all goods. If you're a student spending 40% on food and 30% on transport, your personal inflation is weighted toward those categories — which might be inflating at 5-6%. We take the user's spending breakdown by category — food, housing, transport, education, healthcare, other — and weight the official CPI sub-indices by their actual spending proportions. The result is a personalized inflation rate that Gemini uses when projecting savings goals and retirement timelines. It makes every financial plan grounded in the user's reality, not national averages."

**If pushed:** "The CPI sub-indices are published by DOSM (Department of Statistics Malaysia) monthly. We use the latest available data. For the hackathon prototype, the calculation is done in the prompt context sent to Gemini. In production, we'd compute it server-side and cache it."

---

### Q: "How do you handle hallucination? What if Gemini gives wrong financial advice?"
**Intent:** Safety and responsibility.

**Answer:**
"Three safeguards. First, we constrain the prompt — Gemini receives the user's actual financial data, so it's advising on real numbers, not making them up. Second, the system instruction explicitly tells it to reference Malaysian instruments like EPF and PTPTN — this anchors responses in verifiable facts. Third, we include a disclaimer that ssyok Finance is an AI companion, not a licensed financial advisor. For the roadmap, we plan to add fact-checking guardrails — for example, if Gemini suggests an EPF withdrawal rate, we validate it against the actual EPF rules before displaying."

---

### Q: "Why Cloud Functions instead of a persistent server?"
**Intent:** Architecture understanding.

**Answer:**
"Cloud Functions give us three things: zero ops overhead — no servers to maintain; auto-scaling — if we go from 10 to 10,000 users overnight, it just works; and cost efficiency — we only pay per invocation, which is critical for a freemium app where most users are on the free tier. We deploy in `asia-southeast1` (Singapore) for lowest latency to Malaysian users. Each function invocation is stateless, which is actually a feature — conversation history is replayed in the prompt, so there's no session state to manage or lose."

---

### Q: "How do you handle streaming? The AI response appears word by word?"
**Intent:** Technical depth.

**Answer:**
"Yes, we use Server-Sent Events. The Cloud Function sets `Content-Type: text/event-stream` and streams Gemini's response token by token. On the Flutter side, we parse the SSE stream and update the UI in real-time. This gives users immediate feedback — they see the AI 'thinking' rather than waiting 5-10 seconds for a full response. Google ADK supports `StreamingMode.SSE` natively, so we didn't need to build custom chunking."

---

## 2. Technical — Architecture & Stack

### Q: "Why Flutter instead of native Android/iOS?"
**Intent:** Did you choose Flutter just because it's Google?

**Answer:**
"Flutter gives us cross-platform from a single codebase — critical for a solo developer. But more importantly, Flutter's widget composition model and hot reload let me iterate faster than any native framework. The app uses Riverpod for state management and GoRouter for navigation — production patterns, not tutorial code. And yes, it's Google — which means first-class Firebase integration, FlutterFire plugins, and Gemini SDK support out of the box."

---

### Q: "How is the data stored? Is it secure?"
**Intent:** Privacy and security awareness.

**Answer:**
"All user financial data is stored in Firestore with security rules scoped to each authenticated user — you can only read and write your own data. Authentication is Firebase Auth with Google Sign-In, so we never handle passwords. The Gemini API key is stored as a Firebase Secret — it never touches the client. All communication between the Flutter app and Cloud Functions is over HTTPS. The user's financial data never leaves the Google Cloud ecosystem."

---

### Q: "You said you're a solo developer. How did you build all this?"
**Intent:** Credibility check — is this real?

**Answer:**
"I'm the CEO and lead engineer, but I had two AI co-builders. Claude helped me architect the codebase, write the Flutter features, and debug issues — that's my CTO. Gemini powers the product's AI brain — that's my AI Product Lead. This is genuinely an AI-built-with-AI product. Every line of code is in the GitHub repo — you can verify the commit history. The fact that one person can build a production-quality fintech app in weeks is itself a demonstration of what Google AI enables."

---

## 3. Business Model & Monetization

### Q: "RM 4.90/month seems very cheap. How do you make money?"
**Intent:** Is this financially viable?

**Answer:**
"RM 4.90 is intentional — it's the price of one teh tarik. The target is young Malaysians who earn RM 2-4k/month. At that price point, we minimize friction to convert. Our unit economics work because Gemini 2.5 Flash is extremely cost-effective — 100 AI responses per user per month costs us roughly RM 0.50-1.00 in API calls. The rest is margin. Free tier users generate revenue through Google AdMob. At 100K users with 5% conversion, that's 5,000 paid users at RM 4.90 = RM 24,500/month recurring. Plus AdMob revenue from 95K free users."

**If pushed:** "As we scale, we add higher-margin features — insurance comparison (affiliate commissions), investment products (referral fees), open banking partnerships. The subscription is the entry point, not the ceiling."

---

### Q: "Why would someone pay when free tools exist?"
**Intent:** Value proposition challenge.

**Answer:**
"Free tools give you spreadsheets and calculators. ssyok Finance gives you a financial advisor that knows your name, your spending patterns, and your goals — in Manglish. The free tier already includes the dashboard, goals, and calculators. You only pay for deeper AI interaction — 100 responses vs 5. And RM 4.90/month vs RM 300-600/hour for a real Certified Financial Planner? That's not even a comparison. We're democratizing access to personalized financial guidance."

---

### Q: "What happens when Gemini API pricing changes?"
**Intent:** Dependency risk.

**Answer:**
"Good question. Three mitigations. First, Gemini Flash is already the most cost-effective model in the market — Google is actively driving costs down, not up. Second, our architecture is model-agnostic at the agent layer — we use Google ADK, so swapping to a newer or cheaper Gemini model is a config change, not a rewrite. Third, our pricing has healthy margins — even if API costs doubled, we'd still be profitable at RM 4.90. But historically, AI API pricing has only gone down."

---

## 4. SDG & Impact

### Q: "How does this actually advance SDG 8.10?"
**Intent:** Is the SDG alignment real or just painted on?

**Answer:**
"SDG 8.10 says: strengthen access to banking, insurance, and financial services *for all*. The keyword is 'for all.' A CFP costs RM 300-600/hour — that's not 'for all.' ssyok Finance provides the same quality financial guidance for free. Specifically: savings planning (banking), insurance coverage tracking (insurance), and AI-powered financial education (financial services). Every user we onboard — especially fresh graduates who have zero access to professional advice — directly advances this target. The 89% with bank accounts but 59.1/100 literacy score proves that access without understanding is not true access."

---

### Q: "How do you measure impact?"
**Intent:** Is impact measurable or just aspirational?

**Answer:**
"Three concrete metrics. First, financial literacy improvement — we can measure the quality and frequency of AI interactions, showing users are actively learning. Second, savings goal completion rate — users who set goals and hit them are demonstrably better off financially. Third, debt reduction tracking — users who use the debt snowball feature and reduce their outstanding balances. By Year 1, we target 100,000 users. Even if 10% of them make one better financial decision because of ssyok Finance, that's 10,000 young Malaysians who are less likely to join the 53,000 in debt."

---

### Q: "53,000 youths in debt — isn't that a small number relative to Malaysia's population?"
**Intent:** Testing your data literacy.

**Answer:**
"53,000 is the number who sought help from AKPK — the Credit Counselling and Debt Management Agency. That's the tip of the iceberg. These are people who were already in serious enough trouble to seek professional debt counseling. The actual number of financially struggling youth is far higher — they just haven't hit the crisis point yet. And RM 1.9 billion in combined debt for under-30s? That's a systemic problem, not a rounding error. Prevention is cheaper than cure — that's where ssyok Finance comes in."

---

## 5. Users & Market

### Q: "Who is your target user exactly?"
**Intent:** Specificity check.

**Answer:**
"Our primary target is Malaysian fresh graduates aged 22-28, earning their first salary (typically RM 2,500-4,000/month), who have never used a financial planner. They're digital natives — they'll use an app but won't visit a bank branch for advice. They understand Manglish. They have EPF deductions they don't understand, PTPTN loans they're not sure how to repay optimally, and savings goals they haven't structured. That's our user. Khai Shen — the friend in our origin story — is literally this person."

---

### Q: "How do you acquire users? University partnerships sound nice but how?"
**Intent:** Is the GTM realistic?

**Answer:**
"Three channels, all free to start. First, TikTok content — 'Financial Mistakes Malaysian Graduates Make' style content that's educational and shareable. Second, university finance clubs — we offer free workshops on financial planning using ssyok Finance as the tool, which gives us direct user acquisition and feedback. Third, campus ambassadors — students who use and promote the app get ssyok+ AI for free. These are all zero-cost channels. We're not planning to buy ads before product-market fit."

---

### Q: "Raiz exited Malaysia. What makes you think you won't?"
**Intent:** Competitive resilience.

**Answer:**
"Raiz was an Australian company that tried to localize a foreign product. Their core was micro-investing — they needed regulatory approvals, broker partnerships, and Australian management making decisions about Malaysian users. We're the opposite: built in Malaysia, for Malaysians, by a Malaysian. Our core is AI financial guidance — no regulatory license required. We don't hold money, we don't execute trades. We're an education and planning tool. Our cost structure is a solo developer plus API calls — not an Australian office with compliance teams. We can sustain this at 1,000 users. Raiz couldn't sustain at 10,000."

---

### Q: "You tested with university students. What did you learn that surprised you?"
**Intent:** Genuine learning from user feedback.

**Answer:**
"Two surprises. First, the Dashboard and Net Worth Graph was the most loved feature — not the AI chat. Users wanted to *see* their financial picture before they wanted advice about it. That validated our 'show first, advise second' design. Second, the top feature request was monthly budgeting and cash flow — which told us users think in monthly cycles, not annual goals. That directly shaped our Q3 2026 roadmap priority. We also got a quote that stuck with me: 'Amazing and structured app for beginners and professionals.' — that told us our UX complexity level was right."

---

## 6. Sustainability & Future

### Q: "What's your plan after the hackathon?"
**Intent:** Is this a real product or just a hackathon project?

**Answer:**
"Concrete roadmap. Q3 2026: launch on Google Play with monthly budgeting — the top user-requested feature. Q4 2026: integrate open banking APIs so users can auto-import transactions instead of manual entry. 2027: add insurance comparison and EPF optimization — that's where we start generating affiliate revenue and become a full financial platform. The code is open source on GitHub, the architecture is production-ready with Cloud Functions and Firestore, and the business model is self-sustaining from Day 1 via AdMob. This isn't a prototype that needs to be rebuilt — it's a product that needs to grow."

---

### Q: "How do you handle Malaysia's financial regulations?"
**Intent:** Regulatory awareness.

**Answer:**
"Important distinction: we are a financial *education and planning* tool, not a financial *services provider*. We don't hold money, don't execute trades, don't sell insurance, and don't manage investments. We provide AI-generated guidance and tracking tools. This means we don't need a Capital Markets Services License from the Securities Commission or a financial advisor license from BNM. We're in the same category as budgeting apps and financial calculators. When we eventually add insurance comparison or investment features in 2027, we'll partner with licensed providers and operate as a referral platform — not a licensed entity ourselves."

---

### Q: "What if Google discontinues ADK or changes Gemini's terms?"
**Intent:** Platform dependency risk.

**Answer:**
"Our agent code is 145 lines. The core logic — prompt engineering, financial context injection, response streaming — is in *our* code, not in ADK. ADK is a convenience layer for session management and streaming. If Google changed terms tomorrow, we could swap to calling the Gemini API directly via the `@google/genai` SDK in an afternoon. Our real IP is the Malaysian financial prompt engineering and the user experience around it — not the orchestration framework."

---

## 7. Team & Execution

### Q: "How can one person maintain this?"
**Intent:** Feasibility of solo execution.

**Answer:**
"The same way one person built it — with AI. Claude handles code architecture and implementation. Gemini powers the product. Firebase handles infrastructure — serverless means zero ops. I focus on product decisions, user feedback, and growth. Modern tooling means a solo developer in 2026 can do what a 5-person team did in 2020. Also, after KitaHack, I'm open to bringing on a co-founder — particularly someone strong in marketing or fintech partnerships."

---

### Q: "Why 'Hokkien Mee is Red'?"
**Intent:** They're curious or testing personality.

**Answer:** *(smile)*
"Because it is. If you think it's black, we need to talk. But seriously — the name is memorable, it's Malaysian, and it shows we don't take ourselves too seriously. Finance is intimidating enough. We want to be the app that feels like a friend, not a bank."

---

## 8. Design Philosophy

### Q: "You mentioned first principles — why planning over tracking?"
**Intent:** Testing depth of product thinking.

**Answer:**
"Every finance app starts with tracking — 'see where your money went.' But from first principles, tracking is reactive. It tells you what already happened. The first principle of growing wealth is *planning* — knowing where every ringgit *should* go before you spend it. That's why our core features are goal-setting, savings planning, and AI-powered financial advice — not receipt scanning or transaction categorization. Tracking looks backward. Planning looks forward. ssyok Finance is built around that distinction."

**If pushed:** "Think of it this way: a diet app that only logs what you ate doesn't help you lose weight. You need a meal *plan*. Same with money. We give users a financial plan powered by Gemini — that's fundamentally different from a tracker."

---

## 9. Curveball Questions

### Q: "Can you show us a live demo right now?"
**Answer:**
"Absolutely. Let me open the app." *(Have the app ready on your phone with test data pre-loaded. Show: Dashboard → tap 'Chat about this' → ask Gemini a question → show streaming response.)*

---

### Q: "What's the one thing you'd build next if you had unlimited resources?"
**Answer:**
"Open banking integration. Right now, users manually enter their financial data. If we could auto-import from Maybank, CIMB, or RHB via open banking APIs, the onboarding friction drops to zero and our AI advice becomes instantly accurate. BNM is actively pushing open banking in Malaysia — the timing is perfect."

---

### Q: "What's your unfair advantage?"
**Answer:**
"Malaysian context. Anyone can build a finance app. No one else is building a Gemini-native financial advisor that speaks Manglish, knows EPF contribution rates, understands PTPTN repayment strategies, and calculates your personal inflation rate based on your actual spending categories. That cultural specificity is our moat — and it's the hardest thing for a foreign competitor to replicate."

---

### Q: "If you could only keep one feature, which one?"
**Answer:**
"The AI chat with financial context. Everything else — dashboard, goals, calculators — exists in other apps. But an AI that has your complete financial picture and gives you personalized, culturally relevant advice in real-time? That doesn't exist for Malaysians today. That's the core."

---

## Quick Reference — Key Numbers

| Metric | Value | Source |
|--------|-------|--------|
| Bank account access | 89% | World Bank Findex 2024 |
| Financial literacy score | 59.1/100 | BNM FCI Survey 2024 (MYFLIC) |
| Youths in debt (AKPK) | 53,000 | AKPK via Malay Mail, Oct 2024 |
| Youth debt total | RM 1.9B | AKPK via Malay Mail, Oct 2024 |
| CFP hourly rate | RM 300-600 | MFPC market rate |
| ssyok+ price | RM 4.90/mo | Our pricing |
| Free tier AI limit | 5/month | Our pricing |
| Paid tier AI limit | 100/month | Our pricing |
| Target users Y1 | 100,000 | Our goal |
| TAM (MY smartphones) | 25M | Market estimate |
| SAM (Gen Z + Millennials) | 10M | Market estimate |
| Deploy region | asia-southeast1 | Singapore (lowest latency to MY) |
