import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/chat/data/chat_repository.dart';
import 'package:ssyok_finance/features/chat/domain/chat_message.dart';
import 'package:ssyok_finance/features/chat/domain/prompt_template.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

// ── Infrastructure providers ──────────────────────────────────────────────

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

// ── State ──────────────────────────────────────────────────────────────────

/// Maximum messages (user + assistant) per in-memory conversation.
/// When hit, the input locks and the user must start a new chat manually.
const int kMaxConversationTurns = 50;

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  /// True when the 50-turn limit has been reached.
  bool get isAtTurnLimit => messages.length >= kMaxConversationTurns;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ── Notifier (Riverpod 2.0) ────────────────────────────────────────────────

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState();

  // ── Messaging ──────────────────────────────────────────────────────────

  /// Streams the AI response chunk-by-chunk; state is in-memory only.
  Future<void> sendMessage(String content) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }

    // Block at 50-turn limit — user must open a new session manually.
    if (state.isAtTurnLimit) {
      state = state.copyWith(
        error:
            'This conversation has reached the 50-message limit. '
            'Tap the history icon to start a new chat.',
      );
      return;
    }

    // Append the user message immediately.
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      content: content,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    );

    // Add an empty placeholder for the streaming AI reply.
    final assistantId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    final placeholder = ChatMessage(
      id: assistantId,
      role: ChatRole.assistant,
      content: '',
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, placeholder]);

    try {
      final userData = await _gatherUserData();

      await for (final chunk
          in ref
              .read(chatRepositoryProvider)
              .streamMessage(
                userId: user.uid,
                messages: state.messages
                    .where((m) => m.id != assistantId)
                    .toList(),
                userData: userData,
              )) {
        final updated = state.messages.map((m) {
          if (m.id == assistantId) {
            return m.copyWith(content: m.content + chunk);
          }
          return m;
        }).toList();
        state = state.copyWith(messages: updated);
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      // Remove empty placeholder on error so UI stays clean.
      final msgs = state.messages;
      final last = msgs.isNotEmpty ? msgs.last : null;
      if (last != null && last.id == assistantId && last.content.isEmpty) {
        state = state.copyWith(
          messages: msgs.sublist(0, msgs.length - 1),
          isLoading: false,
          error: e.toString(),
        );
      } else {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  // ── Session management ─────────────────────────────────────────────────

  /// Resets to a blank in-memory chat session.
  void newConversation() => state = const ChatState();

  /// Clears the current error banner without affecting messages.
  void clearError() => state = state.copyWith(clearError: true);

  /// Sends a pre-filled prompt from a PromptTemplate key.
  Future<void> sendPrompt(String promptKey) async {
    await sendMessage(PromptTemplate.getByKey(promptKey));
  }

  // ── Private helpers ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _gatherUserData() async {
    final profile = ref.read(userProfileProvider).value;
    final assets = ref.read(assetsProvider).value ?? [];
    final debts = ref.read(debtsProvider).value ?? [];
    final goals = ref.read(goalsProvider).value ?? [];
    final expenses = ref.read(expensesProvider).value ?? [];

    final context = PromptTemplate.buildContext(
      profile: profile?.toJson() ?? {},
      assets: assets.map((a) => a.toJson()).toList(),
      debts: debts.map((d) => d.toJson()).toList(),
      goals: goals.map((g) => g.toJson()).toList(),
      expenses: expenses.map((e) => e.toJson()).toList(),
    );

    return {
      'profile': profile?.toJson() ?? {},
      'assets': assets.map((a) => a.toJson()).toList(),
      'debts': debts.map((d) => d.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'context': context,
    };
  }
}

// ── Providers ──────────────────────────────────────────────────────────────

/// Riverpod 2.0 NotifierProvider (replaces old StateNotifierProvider).
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
