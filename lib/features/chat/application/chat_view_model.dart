import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/conversation.dart';
import '../../../repositories/providers.dart';
import '../../../repositories/conversation_repository.dart';
import '../../../models/message.dart';

class ChatState {
  final String? conversationId;
  final String input;
  final String answer;
  final bool loading;
  final List<String> citations;
  final List<ConversationSummary> history;
  final String? error;
  final List<Message> messages;

  const ChatState({
    required this.conversationId,
    required this.input,
    required this.answer,
    required this.loading,
    required this.citations,
  required this.history,
  required this.messages,
  this.error,
  });

  ChatState copyWith({
    String? conversationId,
    String? input,
    String? answer,
    bool? loading,
    List<String>? citations,
    List<ConversationSummary>? history,
  String? error,
  List<Message>? messages,
  }) =>
      ChatState(
        conversationId: conversationId ?? this.conversationId,
        input: input ?? this.input,
        answer: answer ?? this.answer,
        loading: loading ?? this.loading,
        citations: citations ?? this.citations,
        history: history ?? this.history,
    error: error ?? this.error,
    messages: messages ?? this.messages,
      );

  static ChatState initial(List<ConversationSummary> history) => ChatState(
        conversationId: null,
        input: '',
        answer: '',
        loading: false,
        citations: const [],
        history: history,
  error: null,
  messages: const [],
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
    // Append user message immediately
    final updatedMessages = List<Message>.from(state.messages)
      ..add(Message(role: MessageRole.user, content: question));
    state = state.copyWith(
      loading: true,
      answer: '',
      citations: const [],
      error: null,
      messages: updatedMessages,
      input: '',
    );
    try {
      final stream = _repo.ask(
        conversationId: state.conversationId,
        question: question,
      );
      bool assistantBubbleAdded = false;
      await for (final e in stream) {
        if (e.started) {
          state = state.copyWith(conversationId: e.id);
        } else if (e.completed) {
          // Final assistant message
          final msgs = List<Message>.from(state.messages);
          if (assistantBubbleAdded && msgs.isNotEmpty && msgs.last.role == MessageRole.assistant) {
            msgs[msgs.length - 1] = Message(role: MessageRole.assistant, content: e.content ?? state.answer);
          } else {
            msgs.add(Message(role: MessageRole.assistant, content: e.content ?? state.answer));
          }
          state = state.copyWith(
            answer: e.content ?? state.answer,
            citations: e.citations ?? const [],
            loading: false,
            history: _repo.listSummaries(),
            messages: msgs,
          );
        } else if (e.content != null) {
          // Streaming delta: update or insert assistant bubble
          final msgs = List<Message>.from(state.messages);
          if (assistantBubbleAdded && msgs.isNotEmpty && msgs.last.role == MessageRole.assistant) {
            msgs[msgs.length - 1] = Message(role: MessageRole.assistant, content: e.content!);
          } else {
            msgs.add(Message(role: MessageRole.assistant, content: e.content!));
            assistantBubbleAdded = true;
          }
          state = state.copyWith(answer: e.content, messages: msgs);
        }
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
