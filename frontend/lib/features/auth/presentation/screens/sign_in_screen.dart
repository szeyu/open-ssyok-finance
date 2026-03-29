import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  // Entrance animation state
  bool _logoVisible = false;
  bool _taglineVisible = false;
  bool _buttonVisible = false;

  @override
  void initState() {
    super.initState();
    // Staggered entrance
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _logoVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _taglineVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _buttonVisible = true);
    });
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final signIn = ref.read(signInProvider);
      await signIn();

      if (mounted) {
        // Navigation will be handled by router auth guard
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branded text logo with fade + scale entrance
                AnimatedOpacity(
                  opacity: _logoVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: AnimatedScale(
                    scale: _logoVisible ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    child: Column(
                      children: [
                        Text(
                          'ssyok',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Finance',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.primary.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tagline with delay
                AnimatedOpacity(
                  opacity: _taglineVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: Text(
                    'Your financial companion for a better tomorrow',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                // Features list with subtle background container
                AnimatedOpacity(
                  opacity: _taglineVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          context,
                          Icons.calculate,
                          'Track your assets, debts, and goals',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          context,
                          Icons.lightbulb_outline,
                          'Get personalized AI insights powered by Gemini',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          context,
                          Icons.trending_up,
                          'Plan for your financial independence',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Sign in button — fade + slide up with delay
                AnimatedOpacity(
                  opacity: _buttonVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: AnimatedSlide(
                    offset: _buttonVisible ? Offset.zero : const Offset(0, 0.3),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleSignIn,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Image.asset(
                              'assets/images/google_logo.png',
                              height: 20,
                              width: 20,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.login, size: 20);
                              },
                            ),
                      label: Text(
                          _isLoading ? 'Signing in...' : 'Continue with Google'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Privacy text
                AnimatedOpacity(
                  opacity: _buttonVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
