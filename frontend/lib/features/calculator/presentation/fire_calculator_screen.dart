import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';

class FireCalculatorScreen extends StatefulWidget {
  const FireCalculatorScreen({super.key});

  @override
  State<FireCalculatorScreen> createState() => _FireCalculatorScreenState();
}

class _FireCalculatorScreenState extends State<FireCalculatorScreen> {
  final _currentAgeController = TextEditingController(text: '25');
  final _currentSavingsController = TextEditingController(text: '50000');
  final _monthlySavingsController = TextEditingController(text: '2000');
  final _annualExpensesController = TextEditingController(text: '36000');
  final _returnRateController = TextEditingController(text: '7');
  final _withdrawalRateController = TextEditingController(text: '4');

  double? _fireNumber;
  double? _yearsToFire;
  int? _fireAge;
  double? _monthlySavingsNeeded;
  double? _progressPercent;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _currentAgeController.dispose();
    _currentSavingsController.dispose();
    _monthlySavingsController.dispose();
    _annualExpensesController.dispose();
    _returnRateController.dispose();
    _withdrawalRateController.dispose();
    super.dispose();
  }

  void _calculate() {
    final currentAge = int.tryParse(_currentAgeController.text) ?? 25;
    final currentSavings =
        double.tryParse(_currentSavingsController.text.replaceAll(',', '')) ?? 0;
    final monthlySavings =
        double.tryParse(_monthlySavingsController.text.replaceAll(',', '')) ?? 0;
    final annualExpenses =
        double.tryParse(_annualExpensesController.text.replaceAll(',', '')) ?? 0;
    final returnRate = double.tryParse(_returnRateController.text) ?? 7;
    final withdrawalRate = double.tryParse(_withdrawalRateController.text) ?? 4;

    if (annualExpenses <= 0 || withdrawalRate <= 0) return;

    final fireNumber = annualExpenses / (withdrawalRate / 100);
    final monthlyRate = returnRate / 100 / 12;

    // Calculate years to FIRE
    double balance = currentSavings;
    int months = 0;
    const maxMonths = 12 * 100;

    while (balance < fireNumber && months < maxMonths) {
      balance = balance * (1 + monthlyRate) + monthlySavings;
      months++;
    }

    final yearsToFire = months / 12;
    final fireAge = currentAge + yearsToFire.ceil();

    // Monthly savings needed if user wants to retire at a target (e.g. current age + 20)
    final targetYears = 20;
    final targetMonths = targetYears * 12;
    double needed = 0;
    if (monthlyRate > 0) {
      // PMT formula: FV = PV*(1+r)^n + PMT * ((1+r)^n - 1) / r
      final factor = pow(1 + monthlyRate, targetMonths);
      final remaining = fireNumber - currentSavings * factor;
      needed = remaining * monthlyRate / (factor - 1);
      if (needed < 0) needed = 0;
    }

    setState(() {
      _fireNumber = fireNumber;
      _yearsToFire = months < maxMonths ? yearsToFire : null;
      _fireAge = months < maxMonths ? fireAge : null;
      _monthlySavingsNeeded = needed > 0 ? needed : null;
      _progressPercent = (currentSavings / fireNumber * 100).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FIRE Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About FIRE',
            onPressed: () => _showFIREInfo(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Financial Details',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            controller: _currentAgeController,
                            label: 'Current Age',
                            suffix: ' years',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            controller: _currentSavingsController,
                            label: 'Current Savings',
                            prefix: 'RM ',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            controller: _monthlySavingsController,
                            label: 'Monthly Savings',
                            prefix: 'RM ',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            controller: _annualExpensesController,
                            label: 'Annual Expenses',
                            prefix: 'RM ',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            controller: _returnRateController,
                            label: 'Expected Return',
                            suffix: '% /yr',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            controller: _withdrawalRateController,
                            label: 'Withdrawal Rate',
                            suffix: '% /yr',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _calculate,
                        child: const Text('Calculate FIRE'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_fireNumber != null) ...[
              // FIRE Number
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Your FIRE Number',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        _fireNumber!.toRinggit(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(annual expenses ÷ ${_withdrawalRateController.text}% withdrawal rate)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Progress
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Current Progress',
                              style: theme.textTheme.titleSmall),
                          Text(
                            '${_progressPercent!.toStringAsFixed(1)}%',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progressPercent! / 100,
                          minHeight: 12,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Stats grid
              Row(
                children: [
                  if (_yearsToFire != null)
                    Expanded(
                      child: _resultCard(context,
                          label: 'Years to FIRE',
                          value: _yearsToFire!.toStringAsFixed(1),
                          color: Colors.orange,
                          icon: Icons.schedule),
                    ),
                  if (_yearsToFire != null && _fireAge != null)
                    const SizedBox(width: 12),
                  if (_fireAge != null)
                    Expanded(
                      child: _resultCard(context,
                          label: 'FIRE Age',
                          value: '$_fireAge',
                          color: Colors.purple,
                          icon: Icons.celebration),
                    ),
                ],
              ),
              if (_monthlySavingsNeeded != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('To FIRE in 20 years:',
                                  style: theme.textTheme.labelMedium),
                              Text(
                                'Save ${_monthlySavingsNeeded!.toRinggit()}/month',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_yearsToFire == null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.orange.withValues(alpha: 0.1),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'At current savings rate, FIRE may take over 100 years. '
                            'Consider increasing monthly savings.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      onChanged: (_) => _calculate(),
    );
  }

  Widget _resultCard(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showFIREInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('What is FIRE?'),
        content: const Text(
          'FIRE = Financial Independence, Retire Early\n\n'
          '• Your FIRE Number is the amount you need to never work again\n'
          '• It equals your annual expenses ÷ safe withdrawal rate (usually 4%)\n'
          '• The 4% rule means you can withdraw 4% per year indefinitely\n'
          '• Example: RM 36,000/year ÷ 4% = RM 900,000 FIRE number\n\n'
          'Popular in Malaysia as "FI" — reaching EPF Target I (RM240k) is a mini-milestone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
