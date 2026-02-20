import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/theme/colors.dart';
import 'package:ssyok_finance/app/theme/theme_provider.dart';
import 'package:ssyok_finance/features/auth/data/auth_repository.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/onboarding/domain/user_profile.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/settings/data/demo_data_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _loadDemoData() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Load Demo Data?'),
        content: const Text(
          'This will replace ALL your current financial data with realistic Malaysian demo data. '
          'Great for testing or showing off the app.\n\nThis cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Load Demo Data'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isLoading = true);
    try {
      await DemoDataService().loadDemoData(user.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo data loaded! Check your Dashboard.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetAllData() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently delete all your assets, debts, goals, and expenses. Your profile will remain.\n\nThis cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isLoading = true);
    try {
      await DemoDataService().resetAllData(user.uid);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('All data cleared.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('You will be returned to the sign-in screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isLoading = true);
    try {
      await AuthRepository().signOut();
      if (mounted) context.go('/signin');
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('No profile found'));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settings',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),

                // ── Profile Card ─────────────────────────────────────────
                _buildProfileCard(
                  context,
                  theme,
                  profile.name,
                  profile.age,
                  profile.userType.displayName,
                ),
                const SizedBox(height: 20),

                // ── Appearance ───────────────────────────────────────────
                _SectionLabel(label: 'APPEARANCE'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    SwitchListTile(
                      value: isDark,
                      onChanged: (val) {
                        ref.read(themeModeProvider.notifier).state = val
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      },
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            key: ValueKey(isDark),
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        isDark ? 'Currently dark' : 'Currently light',
                      ),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── About ────────────────────────────────────────────────
                _SectionLabel(label: 'ABOUT'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsNavItem(
                      icon: Icons.info_outline,
                      label: 'About ssyok Finance',
                      onTap: () => context.push('/settings/about'),
                      isFirst: true,
                    ),
                    _SettingsNavItem(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () => context.push('/settings/help'),
                    ),
                    _SettingsNavItem(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () => context.push('/settings/privacy'),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Data ─────────────────────────────────────────────────
                _SectionLabel(label: 'DATA'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsNavItem(
                      icon: Icons.auto_awesome,
                      iconColor: Colors.blue,
                      label: 'Load Demo Data',
                      subtitle: 'Replace with Malaysian sample data',
                      onTap: _isLoading ? null : _loadDemoData,
                      isFirst: true,
                    ),
                    _SettingsNavItem(
                      icon: Icons.delete_outline,
                      iconColor: theme.colorScheme.error,
                      label: 'Reset All Data',
                      subtitle: 'Delete all assets, debts, goals & expenses',
                      labelColor: theme.colorScheme.error,
                      onTap: _isLoading ? null : _resetAllData,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Account ──────────────────────────────────────────────
                _SectionLabel(label: 'ACCOUNT'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsNavItem(
                      icon: Icons.logout,
                      iconColor: theme.colorScheme.error,
                      label: 'Sign Out',
                      subtitle: profile.name,
                      labelColor: theme.colorScheme.error,
                      onTap: _isLoading ? null : _signOut,
                      isFirst: true,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Footer
                Center(
                  child: Text(
                    'ssyok Finance — KitaHack 2026',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    ThemeData theme,
    String name,
    int age,
    String userType,
  ) {
    return GestureDetector(
      onTap: () => context.push('/settings/edit-profile'),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Set your name',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    age > 0 ? '$age years • $userType' : userType,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  const _SettingsNavItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.iconColor,
    this.labelColor,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? AppColors.primary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(16) : Radius.zero,
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 60,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}
