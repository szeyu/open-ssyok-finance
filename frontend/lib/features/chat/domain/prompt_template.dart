/// Prompt templates for Gemini AI with Malaysian context
class PromptTemplate {
  /// Get prompt for net worth analysis
  static String netWorthAnalysis() {
    return '''
Analyze my current net worth and provide insights on my financial health.
Consider Malaysian context like EPF contributions, ASB investments, and PTPTN loans.
Give me 3-4 actionable recommendations to improve my financial situation.
''';
  }

  /// Get prompt for asset allocation analysis
  static String assetAllocation() {
    return '''
Review my current asset allocation and suggest improvements.
Consider Malaysian investment options like ASB, EPF, unit trusts, and REIT.
What's the optimal balance for someone in my situation?
Include emergency fund recommendations (3-6 months of expenses).
''';
  }

  /// Get prompt for goal progress analysis
  static String goalProgress() {
    return '''
Analyze my progress towards my financial goals.
For each goal, tell me:
1. Am I on track?
2. How much should I save monthly?
3. Any suggestions to reach it faster?
Consider Malaysian savings options and inflation rates.
''';
  }

  /// Get prompt for debt payoff strategy
  static String debtPayoff() {
    return '''
Analyze my debts and create a payoff strategy.
Prioritize debts by interest rate (avalanche method).
Consider Malaysian context:
- PTPTN has income-based repayment and potential discounts
- Credit cards typically 15-18% interest
- Personal loans 6-12% interest
Give me a month-by-month payment plan to become debt-free faster.
''';
  }

  /// Get prompt for expense optimization
  static String expenseOptimization() {
    return '''
Review my monthly expenses and suggest optimizations.
Consider Malaysian cost of living:
- Food: cooking at home vs mamak vs restaurants
- Transport: public transport vs Grab vs car ownership
- Housing: rent vs mortgage in major cities
Identify areas where I'm overspending and suggest realistic savings targets.
''';
  }

  /// Get prompt by key
  static String getByKey(String key) {
    switch (key) {
      case 'net_worth':
        return netWorthAnalysis();
      case 'assets':
        return assetAllocation();
      case 'goals':
        return goalProgress();
      case 'debts':
        return debtPayoff();
      case 'expenses':
        return expenseOptimization();
      default:
        return 'Help me understand my financial situation.';
    }
  }

  /// Build context for the AI with user data
  static String buildContext({
    required Map<String, dynamic> profile,
    required List<Map<String, dynamic>> assets,
    required List<Map<String, dynamic>> debts,
    required List<Map<String, dynamic>> goals,
    required List<Map<String, dynamic>> expenses,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('User Profile:');
    buffer.writeln('- Name: ${profile['name']}');
    buffer.writeln('- Age: ${profile['age']}');
    buffer.writeln('- User Type: ${profile['userType']}');
    buffer.writeln();

    if (assets.isNotEmpty) {
      buffer.writeln('Assets:');
      for (final asset in assets) {
        buffer.writeln(
            '- ${asset['name']}: RM ${asset['value'].toStringAsFixed(2)} (${asset['type']})');
      }
      buffer.writeln();
    }

    if (debts.isNotEmpty) {
      buffer.writeln('Debts:');
      for (final debt in debts) {
        buffer.writeln(
            '- ${debt['name']}: RM ${debt['balance'].toStringAsFixed(2)} at ${debt['interestRate']}% interest (${debt['type']})');
      }
      buffer.writeln();
    }

    if (goals.isNotEmpty) {
      buffer.writeln('Goals:');
      for (final goal in goals) {
        buffer.writeln(
            '- ${goal['name']}: RM ${goal['currentAmount'].toStringAsFixed(2)} / RM ${goal['targetAmount'].toStringAsFixed(2)} (${goal['type']})');
      }
      buffer.writeln();
    }

    if (expenses.isNotEmpty) {
      buffer.writeln('Monthly Expenses:');
      for (final expense in expenses) {
        buffer.writeln(
            '- ${expense['category']}: RM ${expense['monthlyAmount'].toStringAsFixed(2)}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
