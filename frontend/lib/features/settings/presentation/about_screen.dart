import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/theme/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'About',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Icon
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ssyok Finance',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0-beta',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // About This App
            _SectionCard(
              title: 'About This App',
              children: [
                _DescText(
                  'ssyok Finance is your personal financial planning companion, designed to help you take control of your money and build wealth for the future.',
                ),
                const SizedBox(height: 8),
                _DescText(
                  'Track your assets, set meaningful goals, manage debts, and learn essential financial concepts—all in one beautiful, easy-to-use app.',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Key Features
            _SectionCard(
              title: 'Key Features',
              children: [
                _FeatureItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Asset Tracking',
                  description:
                      'Monitor all your assets in one place with growth projections',
                ),
                _FeatureItem(
                  icon: Icons.flag_outlined,
                  title: 'Goal Planning',
                  description:
                      'Set SMART financial goals and track your progress',
                ),
                _FeatureItem(
                  icon: Icons.trending_down,
                  title: 'Inflation Awareness',
                  description:
                      'See real purchasing power with inflation-adjusted values',
                ),
                _FeatureItem(
                  icon: Icons.menu_book_outlined,
                  title: 'Financial Education',
                  description: 'Learn with articles covering essential topics',
                ),
                _FeatureItem(
                  icon: Icons.calculate_outlined,
                  title: 'Financial Calculators',
                  description:
                      'Plan with compound interest and inflation calculators',
                ),
                _FeatureItem(
                  icon: Icons.smart_toy_outlined,
                  title: 'AI Financial Advisor',
                  description:
                      'Get personalized advice from your AI financial companion',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Developer
            _SectionCard(
              title: 'Developer',
              children: [
                _DescText('Built with ❤️ by ssyok'),
                const SizedBox(height: 8),
                _DescText(
                  'Empowering individuals to achieve financial independence through better planning and education.',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Legal
            _SectionCard(
              title: 'Legal',
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                  onTap: () => context.push('/settings/privacy'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This app is for educational and planning purposes only. Not financial advice. Consult a professional for personalized guidance.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DescText extends StatelessWidget {
  const _DescText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
        height: 1.5,
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
