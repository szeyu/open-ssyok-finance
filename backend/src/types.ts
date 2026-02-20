export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
}

export interface UserProfile {
  name: string;
  age: number;
  userType: string;
}

export interface Asset {
  name: string;
  value: number;
  type: string;
  monthlyContribution?: number;
  growthRate?: number;
}

export interface Debt {
  name: string;
  balance: number;
  interestRate: number;
  type?: string;
  monthlyPayment?: number;
}

export interface Goal {
  name: string;
  targetAmount: number;
  currentAmount: number;
  type?: string;
  targetDate?: string;
}

export interface Expense {
  category: string;
  monthlyAmount: number;
  inflationRate?: number;
}

export interface UserData {
  profile: UserProfile;
  assets: Asset[];
  debts: Debt[];
  goals: Goal[];
  expenses: Expense[];
  context: string; // Pre-built summary string from Flutter
}

export interface ChatRequest {
  userId: string;
  messages: ChatMessage[];
  userData: UserData;
}
