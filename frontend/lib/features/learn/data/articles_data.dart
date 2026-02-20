class Article {
  final String id;
  final String title;
  final String preview;
  final String readTime;
  final String emoji;
  final String content;

  const Article({
    required this.id,
    required this.title,
    required this.preview,
    required this.readTime,
    required this.emoji,
    required this.content,
  });
}

const List<Article> kArticles = [
  Article(
    id: 'compound-interest',
    title: 'The Power of Compound Interest',
    preview: 'Why starting early is the single most impactful financial decision you can make.',
    readTime: '5 min read',
    emoji: '📈',
    content: '''
# The Power of Compound Interest

Albert Einstein allegedly called compound interest "the eighth wonder of the world." Whether he said it or not, the math speaks for itself.

## What Is Compound Interest?

Compound interest means **earning returns on your returns**. Your money earns interest, and then that interest earns interest too — creating a snowball effect.

**Simple interest example:**
- Invest RM 10,000 at 7% for 10 years
- You earn RM 700/year
- After 10 years: **RM 17,000**

**Compound interest example:**
- Invest RM 10,000 at 7% compounded annually for 10 years
- After 10 years: **RM 19,672**

The difference is RM 2,672 — earned just from reinvesting returns.

## The Rule of 72

Want to quickly estimate how long it takes to double your money? Divide 72 by your annual return rate:

- At 6% return: 72 ÷ 6 = **12 years** to double
- At 8% return: 72 ÷ 8 = **9 years** to double
- At 12% return: 72 ÷ 12 = **6 years** to double

## Why Starting Early Matters

Here's a comparison of two Malaysians:

| | Ali | Siti |
|---|---|---|
| Starts investing | Age 25 | Age 35 |
| Monthly investment | RM 500 | RM 500 |
| Annual return | 7% | 7% |
| Stops at | Age 55 | Age 55 |
| **Total invested** | RM 180,000 | RM 120,000 |
| **Final amount** | **RM 567,000** | **RM 284,000** |

Ali invested RM 60,000 more but ended up with **RM 283,000 more**. The extra 10 years did all the heavy lifting.

## Where Malaysians Can Invest

1. **ASB (Amanah Saham Bumiputera)** — 5–7% annual returns, very low risk, capital guaranteed
2. **EPF (KWSP)** — historically 5–6% returns, automatic via salary deduction
3. **Unit Trusts / Mutual Funds** — variable, 6–12% long-term for equity funds
4. **Stocks / ETFs** — higher potential returns, higher volatility

## The Time Is Now

The best time to start investing was yesterday. The second best time is today. Even RM 100/month makes a meaningful difference over 30 years.

> **RM 100/month at 7% for 30 years = RM 121,997**

Use the Compound Interest Calculator in this app to see your own numbers!
''',
  ),
  Article(
    id: 'index-funds',
    title: 'Index Funds 101',
    preview: 'The boring investment strategy that beats 90% of fund managers — and why it works.',
    readTime: '6 min read',
    emoji: '📊',
    content: '''
# Index Funds 101

If you want to invest but don't want to pick stocks, index funds might be the perfect solution. They're simple, cheap, and backed by decades of data.

## What Is an Index Fund?

An index fund tracks a market index — like all the companies in the S&P 500 or Bursa Malaysia. Instead of a fund manager picking stocks, the fund automatically holds all stocks in the index.

**Key advantage:** You own a tiny piece of hundreds of companies at once.

## Why They Outperform Active Funds

Studies consistently show that **over 10+ years, 80–90% of actively managed funds underperform their benchmark index**. Why?

1. **Lower fees** — Active funds charge 1.5–2.5% per year. Index funds charge 0.1–0.5%.
2. **No manager risk** — No single person making poor decisions
3. **Built-in diversification** — Spreading risk across many companies

## Fees Matter More Than You Think

A 1.5% fee doesn't sound like much, but over 30 years on RM 500/month:

- **0.5% fee** → Final value: **RM 590,000**
- **2.0% fee** → Final value: **RM 487,000**

The difference? **RM 103,000** — almost 18% of your final wealth, eaten by fees.

## Malaysian Options

### EPF Members Investment Scheme (MIS)
- Transfer up to 30% of EPF Account 1 savings to approved unit trusts
- Accessible via your EPF i-Akaun

### ASB (for Bumiputera)
- Fixed income fund, not technically an index fund
- But similar "set and forget" approach with good returns

### Bursa Malaysia ETFs
- **MyETF MSCI Malaysia** (MYETF) — tracks Malaysian companies
- **MyETF MSCI SEA Islamic** — ASEAN exposure
- Buy via any stockbroking account

### International Index Funds
- **Versa x Fullerton** — access to global equity index funds
- **StashAway** — robo-advisor using ETFs
- **Wahed Invest** — Shariah-compliant global portfolios

## The Simple 3-Fund Strategy

A popular approach for Malaysians:
1. **40% EPF** — local bonds/fixed income
2. **40% ASB / Unit Trust** — local equity
3. **20% Global ETF** — international diversification

## Getting Started

1. Open a CDS account at any stockbroker (Rakuten, Maybank IB, etc.)
2. Fund with RM 500–1,000
3. Buy ETF units monthly (dollar-cost averaging)
4. Reinvest dividends
5. Don't check the price every day — time in market beats timing the market!
''',
  ),
  Article(
    id: 'understanding-fire',
    title: 'Understanding FIRE',
    preview: 'Financial Independence, Retire Early — what it means and how to calculate your number.',
    readTime: '7 min read',
    emoji: '🔥',
    content: '''
# Understanding FIRE

FIRE stands for **Financial Independence, Retire Early**. It's a lifestyle movement focused on aggressive saving and investing to reach financial independence — the point where your investments generate enough passive income to cover your expenses forever.

## The Core Idea

When your **investment income ≥ your annual expenses**, you are financially independent. You can choose to stop working, work part-time, or pursue passion projects.

## The 25x Rule

Your FIRE number = **annual expenses × 25**

**Why 25?** It's based on the **4% rule** — research showing that a portfolio can sustain a 4% withdrawal rate for 30+ years.

**Example:**
- Annual expenses: RM 36,000/year
- FIRE number: RM 36,000 × 25 = **RM 900,000**
- At FIRE: Withdraw 4% = RM 36,000/year (your expenses exactly)

## Types of FIRE

| Type | What it means |
|------|---------------|
| **Lean FIRE** | Minimize expenses, reach FIRE faster |
| **Fat FIRE** | Higher spending, larger portfolio needed |
| **Barista FIRE** | Semi-retire, work part-time for benefits |
| **Coast FIRE** | Save enough early, then let compound interest do the work |

## Coast FIRE for Young Malaysians

**Coast FIRE** is particularly powerful if you're in your 20s:

> Invest aggressively early, reach your "Coast Number," then you only need to cover expenses (not save more) until retirement age.

**Example:**
- Target: RM 1M at age 60
- Current age: 25 (35 years of growth)
- At 7% returns, your Coast Number = RM 1M ÷ (1.07)³⁵ = **RM 90,000**

Invest RM 90,000 by age 25, then just cover your living expenses — the compound growth does the rest!

## FIRE and Malaysia

### EPF as Your FIRE Foundation
- EPF Target I (RM 240,000 by age 55) is a mini-milestone
- EPF Target II (RM 500,000 by age 55) for comfortable retirement
- Use the Employees Provident Fund calculator at kwsp.gov.my

### How Malaysians Can Reach FIRE
1. **Minimize lifestyle inflation** — The biggest threat to FIRE
2. **Maximize EPF contributions** — Employer match is free money
3. **Invest in ASB + Unit Trusts** — Tax-free returns
4. **Reduce big-ticket expenses** — Housing is usually the biggest lever
5. **Build multiple income streams** — Side hustle during accumulation phase

## Is FIRE for Everyone?

Not necessarily. FIRE requires:
- High savings rate (usually 40–60% of income)
- Discipline and delayed gratification
- Investment knowledge and risk tolerance

But **FI (Financial Independence without the RE)** is universally valuable. Even if you love your job, having a financial runway gives you:
- Freedom to take career risks
- Ability to support family without stress
- Option to reduce hours or change careers

## Your Next Step

Use the **FIRE Calculator** in this app to find your number. Even if full FIRE seems distant, seeing your progress toward it is motivating!

> "The goal isn't to stop working. It's to work because you want to, not because you have to."
''',
  ),
];
