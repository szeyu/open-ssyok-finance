import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main scaffold with animated bottom navigation and floating AI button.
class MainScaffold extends StatelessWidget {
  final Widget child;
  final String location;

  const MainScaffold({
    super.key,
    required this.child,
    required this.location,
  });

  int _getCurrentIndex() {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/plan')) return 1;
    if (location.startsWith('/calculator')) return 2;
    if (location.startsWith('/learn')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/plan');
        break;
      case 2:
        context.go('/calculator');
        break;
      case 3:
        context.go('/learn');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: _AnimatedBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        onAiTap: () => context.push('/chat'),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const _navItems = [
  _NavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: 'Dashboard',
  ),
  _NavItem(
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet,
    label: 'Plan',
  ),
  _NavItem(
    icon: Icons.calculate_outlined,
    selectedIcon: Icons.calculate,
    label: 'Calculate',
  ),
  _NavItem(
    icon: Icons.school_outlined,
    selectedIcon: Icons.school,
    label: 'Learn',
  ),
];

class _AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAiTap;

  const _AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onAiTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // First two tabs
              for (int i = 0; i < 2; i++)
                Expanded(
                  child: _NavTab(
                    item: _navItems[i],
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),

              // Centre AI button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _AiButton(onTap: onAiTap, colorScheme: colorScheme),
              ),

              // Last two tabs
              for (int i = 2; i < 4; i++)
                Expanded(
                  child: _NavTab(
                    item: _navItems[i],
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _NavTab({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with spring scale
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: Icon(
                isSelected ? item.selectedIcon : item.icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            // Label with fade
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 200),
              child: Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Animated indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 3,
              width: isSelected ? 20 : 0,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiButton extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _AiButton({required this.onTap, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.tertiary,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
      ),
    );
  }
}
