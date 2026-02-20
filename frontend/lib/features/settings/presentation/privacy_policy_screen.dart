import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/theme/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
            Text(
              'Last updated: February 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),

            _PolicySection(
              title: '1. Information We Collect',
              content:
                  'ssyok Finance collects only the information you provide directly:\n\n'
                  '• Account information (email address via Firebase Authentication)\n'
                  '• Financial data you enter (assets, debts, goals, expenses)\n'
                  '• Profile information (name, age, employment type)\n\n'
                  'We do not collect any sensitive financial credentials, bank account numbers, or payment information.',
            ),
            _PolicySection(
              title: '2. How We Use Your Information',
              content:
                  'Your information is used solely to:\n\n'
                  '• Provide and personalize the app experience\n'
                  '• Calculate financial projections and insights\n'
                  '• Sync your data across devices\n'
                  '• Power the AI financial advisor feature (data is sent to Google Gemini API for processing)\n\n'
                  'We do not sell, rent, or share your personal information with third parties for marketing purposes.',
            ),
            _PolicySection(
              title: '3. Data Storage & Security',
              content:
                  'Your data is stored securely using Google Firebase:\n\n'
                  '• Data is encrypted in transit (TLS) and at rest\n'
                  '• Access is controlled by Firebase Security Rules\n'
                  '• Only you can access your own data\n'
                  '• Firebase is compliant with major security standards',
            ),
            _PolicySection(
              title: '4. AI Features',
              content:
                  'When you use the AI chat feature, your financial data and conversation messages are sent to Google\'s Gemini API to generate responses. '
                  'This data is processed according to Google\'s privacy policy and is not used to train AI models without consent.',
            ),
            _PolicySection(
              title: '5. Data Retention',
              content:
                  'Your data is retained as long as your account is active. You can delete all your financial data at any time via Settings → Reset All Data. '
                  'To delete your account entirely, contact us.',
            ),
            _PolicySection(
              title: '6. Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access all data we hold about you\n'
                  '• Correct inaccurate data\n'
                  '• Delete your data at any time\n'
                  '• Export your data\n\n'
                  'To exercise these rights, use the in-app data management features or contact us.',
            ),
            _PolicySection(
              title: '7. Children\'s Privacy',
              content:
                  'ssyok Finance is not intended for use by children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            _PolicySection(
              title: '8. Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any significant changes by updating the "Last updated" date at the top of this policy.',
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This app is for educational and planning purposes only. Not financial advice. Consult a licensed financial professional for personalized guidance.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
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

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
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
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
