# ssyok Finance — Flutter Frontend Spec

**Project**: KitaHack 2026
**Last Updated**: 2026-02-12
**Status**: All 8 phases complete (Phases 0–7). Backend `/chat` endpoint still needs deployment.

---

## Implementation Status

| Phase | Scope | Status |
|-------|-------|--------|
| 1 | Foundation — theme, auth, routing, navigation | ✅ Done |
| 2 | Onboarding — 3-step flow, user profile | ✅ Done |
| 3 | Dashboard + Plan Hub (read-only views) | ✅ Done |
| 4 | Full CRUD — Assets, Goals, Debts, Expenses | ✅ Done |
| 5 | AI Chat — Gemini via backend, prompt templates | ✅ Done |
| 6 | Calculators (Compound Interest, FIRE) + Learn (3 articles) | ✅ Done |
| 7 | Polish — Settings screen, theme toggle, demo data | ✅ Done |

### What Needs Backend to Work
- AI Chat (`/chat` endpoint) — UI is complete, needs backend deployed with Gemini API key

---

## Navigation Structure

```
Bottom Nav: Dashboard | Plan | Calculate | Learn
Floating Button: 🤖 AI Chat
```

### Route Map

```
/signin                  → SignInScreen
/onboarding              → OnboardingScreen (3-step PageView)
/dashboard               → DashboardScreen (ShellRoute)
/plan                    → PlanHubScreen (ShellRoute)
/calculator              → CalculatorHubScreen (ShellRoute)
/learn                   → LearnScreen (ShellRoute)

/plan/assets             → AssetsScreen
/plan/goals              → GoalsScreen
/plan/debts              → DebtsScreen
/plan/expenses           → ExpensesScreen

/calculator/compound     → CompoundInterestScreen
/calculator/fire         → FireCalculatorScreen

/learn/:id               → ArticleDetailScreen

/chat?prompt=KEY         → ChatScreen (optional pre-filled prompt)
```

---

## Screens Implemented

### Auth & Onboarding
- **SignInScreen** — Google Sign-In button, feature showcase
- **OnboardingScreen** — 3-step PageView: name confirmation → age → user type
  - UserType: debtPayer, freshStart, buildingWealth, fireFocused
  - Saves `UserProfile` to Firestore on completion

### Dashboard
- Greeting (time-of-day aware) with user name
- Net Worth card with gradient + "💬 Chat about this" button → `/chat?prompt=net_worth`
- Quick Actions grid (4 items) — opens Add forms directly
- Summary cards: total assets, debts, monthly expenses, active goals count
- Pull-to-refresh

### Plan Hub
- 4 category cards: Assets, Goals, Debts, Expenses
- Each shows total + item count + "💬 Chat" button
- Tapping navigates to detail screen

### Assets Screen (`/plan/assets`)
- List with total summary bar
- AssetCard: type icon, name, value, monthly contribution, growth rate, emergency fund badge
- Add/Edit via bottom sheet modal (`AssetFormModal`)
  - Fields: type (chip), name, current value, monthly contribution, growth rate %, emergency fund toggle
- Delete with confirmation dialog
- Empty state with CTA

### Goals Screen (`/plan/goals`)
- Overall progress bar (total current / total target)
- GoalCard: type icon, name, per-goal progress bar, days remaining / overdue indicator, completion badge
- Add/Edit via `GoalFormModal` with date picker
- Empty state

### Debts Screen (`/plan/debts`)
- Auto-sorted by interest rate descending (avalanche method)
- DebtCard: type icon, balance, monthly payment, interest rate, payoff timeline, total interest
- Add/Edit via `DebtFormModal`
- Empty state with positive messaging

### Expenses Screen (`/plan/expenses`)
- 6 expandable category cards (Food, Housing, Transport, Education, Healthcare, Other)
- Inline edit: tap category → expand → enter amount → Save
- Set to 0 to remove
- Total monthly summary bar

### AI Chat Screen (`/chat`)
- Empty state with 5 suggested prompt buttons
- Chat bubbles: user (right, primary) + assistant (left, markdown rendered)
- Loading indicator ("AI is thinking...")
- Error banner
- Auto-scroll on new messages
- Pre-filled prompts via `?prompt=KEY` (net_worth, assets, goals, debts, expenses)
- `PromptTemplate` builds context-rich prompts with Malaysian references (EPF, ASB, PTPTN, RM)

### Calculator Hub (`/calculator`)
- 2 cards: Compound Interest + FIRE Calculator

### Compound Interest Calculator
- Inputs: initial amount, monthly contribution, annual return %, years
- Live recalculation on every keystroke
- Results: final amount, total contributions, interest earned
- Bar chart (custom, no external dependency) showing yearly growth

### FIRE Calculator
- Inputs: current age, current savings, monthly savings, annual expenses, return rate %, withdrawal rate %
- Results: FIRE number, years to FIRE, FIRE age, progress bar
- "To FIRE in 20 years" monthly savings suggestion
- Info dialog explaining FIRE + Malaysian EPF context

### Learn Screen (`/learn`)
- 3 article cards with emoji, title, preview, read time

### Article Detail (`/learn/:id`)
- Full markdown rendering with flutter_markdown
- Styled headers, tables, blockquotes, code blocks

**Articles:**
1. The Power of Compound Interest — Rule of 72, ASB/EPF/Unit Trust comparison table
2. Index Funds 101 — fee impact calculator, Malaysian ETF options (Versa, StashAway, Wahed)
3. Understanding FIRE — 25x rule, Coast FIRE for young Malaysians, EPF milestones

---

## Data Models (Freezed + json_serializable)

### UserProfile
```
uid, name, age, userType, currency, hasCompletedOnboarding, createdAt
```

### Asset
```
id, userId, type (savings/investment/property/retirement/other),
name, value, monthlyContribution, growthRate, isEmergencyFund, createdAt, updatedAt
```

### Goal
```
id, userId, type (emergencyFund/house/education/vacation/retirement/other),
name, targetAmount, currentAmount, targetDate, createdAt, updatedAt
Computed: progressPercentage, daysRemaining, isCompleted
```

### Debt
```
id, userId, type (ptptn/creditCard/personalLoan/carLoan/homeLoan/other),
name, balance, interestRate, monthlyPayment, createdAt, updatedAt
Computed: monthsToPayOff, totalInterest (amortization formula)
```

### Expense
```
id, userId, category (food/housing/transport/education/healthcare/other),
monthlyAmount, inflationRate, createdAt, updatedAt
```

### ChatMessage
```
id, role (user/assistant), content, timestamp
```

---

## Firestore Structure

```
users/{uid}/
  profile              → UserProfile document (set with merge)
  assets/{id}          → Asset documents
  goals/{id}           → Goal documents (ordered by targetDate)
  debts/{id}           → Debt documents (ordered by interestRate desc)
  expenses/{id}        → Expense documents (ordered by category)
```

**Security rules**: Each user can only read/write their own `users/{uid}/**` path.

---

## State Management (Riverpod)

```dart
// Auth
authRepositoryProvider     → AuthRepository
authStateProvider          → StreamProvider<User?>
currentUserProvider        → Provider<User?>

// Profile
profileRepositoryProvider  → ProfileRepository
userProfileProvider        → StreamProvider<UserProfile?>
hasCompletedOnboardingProvider → Provider<bool>

// Plan data
assetsRepositoryProvider   → AssetsRepository
goalsRepositoryProvider    → GoalsRepository
debtsRepositoryProvider    → DebtsRepository
expensesRepositoryProvider → ExpensesRepository

assetsProvider             → StreamProvider<List<Asset>>
goalsProvider              → StreamProvider<List<Goal>>
debtsProvider              → StreamProvider<List<Debt>>
expensesProvider           → StreamProvider<List<Expense>>

// Derived
totalAssetsProvider        → Provider<double>
totalGoalsTargetProvider   → Provider<double>
totalGoalsCurrentProvider  → Provider<double>
totalDebtsProvider         → Provider<double>
totalMonthlyExpensesProvider → Provider<double>
netWorthProvider           → Provider<double>

// Chat
chatProvider               → StateNotifierProvider<ChatNotifier, ChatState>
```

---

## Remaining Work

### Critical (requires backend)
- [ ] **Backend `/chat` endpoint** — deploy Cloud Functions with Gemini API key (see `backend/`)

### Nice to have
- [ ] Hero animations between list → detail
- [ ] Offline persistence for Firestore (`Settings(persistenceEnabled: true)`)
- [ ] App icon + splash screen
- [ ] `flutter build apk` for Android demo

---

## Development Commands

```bash
# Run on Chrome
CHROME_EXECUTABLE=/usr/bin/chromium-browser flutter run -d chrome

# Run on Linux desktop
flutter run -d linux

# Analyze
flutter analyze

# Build web
flutter build web
```

## Firebase Setup

See `docs/firebase-setup-guide.md` for the full CLI walkthrough.

**Project**: `smart-bloom-350004` (sandbox)
**Region**: `asia-southeast1`
**Auth**: Google Sign-In enabled, People API enabled
**Web Client ID**: `908117969556-ifarvkn4r5jahd0o09sel425v7u64bkj.apps.googleusercontent.com`
