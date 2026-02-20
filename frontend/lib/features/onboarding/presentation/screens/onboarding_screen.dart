import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/core/services/local_storage_service.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/onboarding/domain/user_profile.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form fields
  String _name = '';
  int _age = 0;
  UserType _userType = UserType.freshStart;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill name from Google account
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateProvider).value;
      if (user?.displayName != null) {
        setState(() {
          _name = user!.displayName!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentPage < 2) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  Future<void> _previousPage() async {
    if (_currentPage > 0) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profile = UserProfile(
        uid: user.uid,
        name: _name,
        age: _age,
        userType: _userType,
        hasCompletedOnboarding: true,
      );

      final profileRepository = ref.read(profileRepositoryProvider);
      await profileRepository.saveProfile(profile);

      // Persist flag locally so the router doesn't redirect back to onboarding
      final localStorageAsync = ref.read(localStorageServiceProvider);
      final localStorage = localStorageAsync.value;
      await localStorage?.setOnboardingComplete(true);
      // Force hasCompletedOnboardingProvider to recompute so the router
      // sees `true` before the navigation redirect fires.
      ref.invalidate(hasCompletedOnboardingProvider);

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
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

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _name.trim().isNotEmpty;
      case 1:
        return _age >= 18 && _age <= 100;
      case 2:
        return true; // User type always has a default value
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(theme),
                  _buildAgePage(theme),
                  _buildUserTypePage(theme),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _previousPage,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canProceed() && !_isLoading ? _nextPage : null,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Welcome to ssyok Finance! 👋',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Let\'s personalize your experience. We\'ll use this information to provide better financial insights.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          TextField(
            decoration: const InputDecoration(
              labelText: 'What should we call you?',
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
            controller: TextEditingController(text: _name)
              ..selection = TextSelection.collapsed(offset: _name.length),
          ),
        ],
      ),
    );
  }

  Widget _buildAgePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'How old are you?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This helps us provide age-appropriate financial advice.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Age',
              hintText: 'Enter your age',
              prefixIcon: Icon(Icons.cake),
              suffixText: 'years old',
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value) ?? 0;
              });
            },
          ),
          if (_age > 0 && (_age < 18 || _age > 100))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Please enter an age between 18 and 100',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserTypePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'What\'s your financial goal?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose the option that best describes your current situation.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ...UserType.values.map((type) => _buildUserTypeCard(theme, type)),
        ],
      ),
    );
  }

  Widget _buildUserTypeCard(ThemeData theme, UserType type) {
    final isSelected = _userType == type;
    final iconMap = {
      UserType.debtPayer: Icons.credit_card,
      UserType.freshStart: Icons.rocket_launch,
      UserType.buildingWealth: Icons.trending_up,
      UserType.fireFocused: Icons.local_fire_department,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _userType = type;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconMap[type],
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
