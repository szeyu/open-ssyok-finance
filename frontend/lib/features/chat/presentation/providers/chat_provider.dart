import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/chat/data/chat_repository.dart';
import 'package:ssyok_finance/features/chat/domain/chat_message.dart';
import 'package:ssyok_finance/features/chat/domain/prompt_template.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

/// Provider for ChatRepository instance
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

/// State for chat messages
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({this.messages = const [], this.isLoading = false, this.error});

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Chat state notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final Ref _ref;

  ChatNotifier(this._chatRepository, this._ref) : super(ChatState());

  /// Send a message and stream the AI response back chunk-by-chunk.
  Future<void> sendMessage(String content) async {
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      content: content,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Add a placeholder assistant message that will grow as chunks arrive
    final assistantId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    final placeholder = ChatMessage(
      id: assistantId,
      role: ChatRole.assistant,
      content: '',
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, placeholder]);

    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userData = await _gatherUserData();

      // Stream chunks from the backend SSE endpoint
      await for (final chunk in _chatRepository.streamMessage(
        userId: user.uid,
        messages:
            // Exclude the empty placeholder from history sent to the server
            state.messages.where((m) => m.id != assistantId).toList(),
        userData: userData,
      )) {
        // Replace only the last (assistant) message by appending the chunk
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
      // If nothing was streamed, remove the empty placeholder
      final msgs = state.messages;
      final lastMsg = msgs.isNotEmpty ? msgs.last : null;
      if (lastMsg != null &&
          lastMsg.id == assistantId &&
          lastMsg.content.isEmpty) {
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

  /// Clear chat history
  void clearChat() {
    state = ChatState();
  }

  /// Dismiss the current error without clearing chat history
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Send pre-filled prompt
  Future<void> sendPrompt(String promptKey) async {
    final prompt = PromptTemplate.getByKey(promptKey);
    await sendMessage(prompt);
  }

  /// Gather user data for context
  Future<Map<String, dynamic>> _gatherUserData() async {
    final profileAsync = _ref.read(userProfileProvider);
    final assetsAsync = _ref.read(assetsProvider);
    final debtsAsync = _ref.read(debtsProvider);
    final goalsAsync = _ref.read(goalsProvider);
    final expensesAsync = _ref.read(expensesProvider);

    final profile = profileAsync.value;
    final assets = assetsAsync.value ?? [];
    final debts = debtsAsync.value ?? [];
    final goals = goalsAsync.value ?? [];
    final expenses = expensesAsync.value ?? [];

    // Build context string
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

/// Provider for chat state
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository, ref);
});
