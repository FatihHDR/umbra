import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/conversation.dart';
import '../../../repositories/conversation_repository.dart';
import '../providers.dart';

class ChatState {
  final String? conversationId;
  final String input;
  final String answer;
  final bool loading;
  final List<String> citations;
  final List<ConversationSummary> history;

  const ChatState({
    required this.conversationId,
    required this.input,
    required this.answer,
    required this.loading,
    required this.citations,
    required this.history,
  });

  ChatState copyWith({
    String? conversationId,
    String? input,
    String? answer,
    bool? loading,
    List<String>? citations,
    List<ConversationSummary>? history,
  }) =>
      ChatState(
        conversationId: conversationId ?? this.conversationId,
        input: input ?? this.input,
        answer: answer ?? this.answer,
        loading: loading ?? this.loading,
        citations: citations ?? this.citations,
        history: history ?? this.history,
      );

  static ChatState initial(List<ConversationSummary> history) => ChatState(
        conversationId: null,
        input: '',
        answer: '',
        loading: false,
        citations: const [],
        history: history,
      );
}

class ChatViewModel extends FamilyNotifier<ChatState, String?> {
  ConversationRepository get _repo => ref.read(conversationRepositoryProvider);

  @override
  ChatState build(String? arg) {
    final history = _repo.listSummaries();
    return ChatState.initial(history);
  }

  void setInput(String value) {
    state = state.copyWith(input: value);
  }

  Future<void> ask() async {
    final question = state.input.trim();
    if (question.isEmpty) return;
    state = state.copyWith(loading: true, answer: '', citations: const []);
    final stream = _repo.ask(
      conversationId: state.conversationId,
      question: question,
    );
    await for (final e in stream) {
      if (e.started) {
        state = state.copyWith(conversationId: e.id);
      } else if (e.completed) {
        state = state.copyWith(
            answer: e.content ?? state.answer,
            citations: e.citations ?? const [],
            loading: false,
            history: _repo.listSummaries());
      } else if (e.content != null) {
        state = state.copyWith(answer: e.content);
      }
    }
  }
}
