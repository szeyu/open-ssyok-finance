import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';

class CompoundInterestScreen extends StatefulWidget {
  const CompoundInterestScreen({super.key});

  @override
  State<CompoundInterestScreen> createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen> {
  final _initialController = TextEditingController(text: '10000');
  final _monthlyController = TextEditingController(text: '500');
  final _rateController = TextEditingController(text: '7');
  final _yearsController = TextEditingController(text: '10');

  double? _finalAmount;
  double? _totalContributions;
  double? _interestEarned;
  List<_DataPoint> _chartData = [];

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _initialController.dispose();
    _monthlyController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _calculate() {
    final initial = double.tryParse(_initialController.text.replaceAll(',', '')) ?? 0;
    final monthly = double.tryParse(_monthlyController.text.replaceAll(',', '')) ?? 0;
    final annualRate = double.tryParse(_rateController.text) ?? 0;
    final years = int.tryParse(_yearsController.text) ?? 0;

    if (years <= 0 || annualRate < 0) return;

    final monthlyRate = annualRate / 100 / 12;
    final months = years * 12;
    final contributions = initial + monthly * months;

    double balance = initial;
    final dataPoints = <_DataPoint>[];

    for (int m = 1; m <= months; m++) {
      balance = balance * (1 + monthlyRate) + monthly;
      if (m % 12 == 0) {
        dataPoints.add(_DataPoint(year: m ~/ 12, value: balance));
      }
    }

    setState(() {
      _finalAmount = balance;
      _totalContributions = contributions;
      _interestEarned = balance - contributions;
      _chartData = dataPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Compound Interest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Inputs card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calculator Inputs',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            controller: _initialController,
                            label: 'Initial Amount',
                            prefix: 'RM ',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            controller: _monthlyController,
                            label: 'Monthly Contribution',
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
                            controller: _rateController,
                            label: 'Annual Return',
                            suffix: '% /yr',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            controller: _yearsController,
                            label: 'Time Period',
                            suffix: ' years',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _calculate,
                        child: const Text('Calculate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            if (_finalAmount != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _resultCard(
                      context,
                      label: 'Final Amount',
                      value: _finalAmount!.toRinggit(),
                      color: Colors.green,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _resultCard(
                      context,
                      label: 'Total Contributed',
                      value: _totalContributions!.toRinggit(),
                      color: Colors.blue,
                      icon: Icons.savings,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _resultCard(
                      context,
                      label: 'Interest Earned',
                      value: _interestEarned!.toRinggit(),
                      color: Colors.teal,
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bar chart (manual)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Growth Over Time',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildBarChart(theme),
                    ],
                  ),
                ),
              ),
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
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme) {
    if (_chartData.isEmpty) return const SizedBox();

    final maxValue = _chartData.map((d) => d.value).reduce(max);

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _chartData.map((point) {
          final height = (point.value / maxValue) * 160;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Y${point.year}',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(fontSize: 9),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DataPoint {
  final int year;
  final double value;
  const _DataPoint({required this.year, required this.value});
}
