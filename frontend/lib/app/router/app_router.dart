import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/router/main_scaffold.dart';
import 'package:ssyok_finance/core/services/local_storage_service.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ssyok_finance/features/chat/presentation/screens/chat_screen.dart';
import 'package:ssyok_finance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/assets/assets_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/debts/debts_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/expenses/expenses_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/goals/goals_screen.dart';
import 'package:ssyok_finance/features/calculator/presentation/calculator_hub_screen.dart';
import 'package:ssyok_finance/features/calculator/presentation/compound_interest_screen.dart';
import 'package:ssyok_finance/features/calculator/presentation/fire_calculator_screen.dart';
import 'package:ssyok_finance/features/learn/presentation/article_detail_screen.dart';
import 'package:ssyok_finance/features/learn/presentation/learn_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/plan_hub_screen.dart';
import 'package:ssyok_finance/features/settings/presentation/settings_screen.dart';
import 'package:ssyok_finance/features/settings/presentation/edit_profile_screen.dart';
import 'package:ssyok_finance/features/settings/presentation/about_screen.dart';
import 'package:ssyok_finance/features/settings/presentation/help_support_screen.dart';
import 'package:ssyok_finance/features/settings/presentation/privacy_policy_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/safety_net/safety_net_screen.dart';
import 'package:ssyok_finance/features/plan/presentation/insurance/insurance_screen.dart';

/// Slide-up + fade transition for detail screens.
CustomTransitionPage<void> _slideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

/// Fade transition (sign-in → dashboard).
CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final localStorageAsync = ref.watch(localStorageServiceProvider);

  return GoRouter(
    initialLocation: '/signin',
    redirect: (context, state) {
      final isAuthLoading = authState.isLoading;
      final isLocalStorageLoading = localStorageAsync.isLoading;
      final isAuthenticated = authState.value != null;
      final isSignInRoute = state.matchedLocation == '/signin';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      // Wait for both auth and local storage before redirecting
      if (isAuthLoading || isLocalStorageLoading) return null;

      if (!isAuthenticated && !isSignInRoute) return '/signin';

      if (isAuthenticated && isSignInRoute) {
        final hasCompleted = ref.read(hasCompletedOnboardingProvider);
        return hasCompleted ? '/dashboard' : '/onboarding';
      }

      if (isAuthenticated && !isOnboardingRoute) {
        final hasCompleted = ref.read(hasCompletedOnboardingProvider);
        if (!hasCompleted) return '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const OnboardingScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            MainScaffold(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/plan',
            builder: (context, state) => const PlanHubScreen(),
          ),
          GoRoute(
            path: '/calculator',
            builder: (context, state) => const CalculatorHubScreen(),
          ),
          GoRoute(
            path: '/learn',
            builder: (context, state) => const LearnScreen(),
          ),
        ],
      ),
      // Detail screens — slide-up transition
      GoRoute(
        path: '/plan/assets',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const AssetsScreen()),
      ),
      GoRoute(
        path: '/plan/goals',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const GoalsScreen()),
      ),
      GoRoute(
        path: '/plan/debts',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const DebtsScreen()),
      ),
      GoRoute(
        path: '/plan/expenses',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const ExpensesScreen()),
      ),
      GoRoute(
        path: '/plan/safetynet',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const SafetyNetScreen()),
      ),
      GoRoute(
        path: '/plan/insurance',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const InsuranceScreen()),
      ),
      GoRoute(
        path: '/calculator/compound',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const CompoundInterestScreen(),
        ),
      ),
      GoRoute(
        path: '/calculator/fire',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const FireCalculatorScreen(),
        ),
      ),
      GoRoute(
        path: '/learn/:id',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: ArticleDetailScreen(articleId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const SettingsScreen()),
      ),
      GoRoute(
        path: '/settings/edit-profile',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const EditProfileScreen()),
      ),
      GoRoute(
        path: '/settings/about',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const AboutScreen()),
      ),
      GoRoute(
        path: '/settings/help',
        pageBuilder: (context, state) =>
            _slideUpPage(key: state.pageKey, child: const HelpSupportScreen()),
      ),
      GoRoute(
        path: '/settings/privacy',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) {
          final promptKey = state.uri.queryParameters['prompt'];
          return _slideUpPage(
            key: state.pageKey,
            child: ChatScreen(initialPromptKey: promptKey),
          );
        },
      ),
    ],
  );
});
