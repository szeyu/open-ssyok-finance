import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/shared/widgets/animated_list_item.dart';
import 'package:ssyok_finance/shared/widgets/pressable.dart';

class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculators')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Financial Tools',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedListItem(
            index: 0,
            child: _CalculatorCard(
              icon: Icons.show_chart,
              title: 'Compound Interest',
              subtitle: 'See how your money grows over time',
              color: Colors.green,
              examples: 'ASB • EPF • Unit Trust',
              onTap: () => context.push('/calculator/compound'),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedListItem(
            index: 1,
            child: _CalculatorCard(
              icon: Icons.beach_access,
              title: 'FIRE Calculator',
              subtitle: 'When can you retire early?',
              color: Colors.orange,
              examples: '4% Rule • 25x Rule • FI Number',
              onTap: () => context.push('/calculator/fire'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String examples;
  final VoidCallback onTap;

  const _CalculatorCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.examples,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Pressable(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        examples,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: color),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
