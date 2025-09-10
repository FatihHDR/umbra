import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

import '../models/message.dart';
import '../models/conversation.dart';
import '../services/deepseek_service.dart';

class ConversationRepository {
  ConversationRepository({DeepSeekService? service, Box? box})
      : _service = service ?? DeepSeekService(),
        _box = box ?? Hive.box('conversations');

  final DeepSeekService _service;
  final Box _box; // key: id, value: json string {messages: [...], updatedAt}

  List<ConversationSummary> listSummaries() {
    return _box.keys.map((key) {
      final raw = _box.get(key) as String;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ConversationSummary(
        id: key as String,
        title: (map['title'] as String?) ?? 'Percakapan',
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<(String id, List<Message> messages)> getConversation(String id) async {
    final raw = _box.get(id) as String?;
    if (raw == null) return (id, const <Message>[]);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final messages = ((map['messages'] as List?) ?? [])
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
    return (id, messages);
  }

  Future<String> createOrGetId(List<Message> messages) async {
    // Use the first user message to derive a title
    final firstUser = messages.firstWhere(
      (m) => m.role == MessageRole.user,
      orElse: () => const Message(role: MessageRole.user, content: 'Umbra'),
    );
    final title = firstUser.content.trim().split('\n').first;
  final id = _randomId();
    await _save(id, messages, title: title);
    return id;
  }

  Future<void> _save(String id, List<Message> messages, {String? title}) async {
    final data = {
      'messages': messages.map((e) => e.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
      if (title != null) 'title': title,
    };
    await _box.put(id, jsonEncode(data));
  }

  Stream<ConversationStreamEvent> ask({
    String? conversationId,
    required String question,
  }) async* {
    List<Message> messages;
    String id;
    if (conversationId != null) {
      final res = await getConversation(conversationId);
      id = res.$1;
      messages = List.of(res.$2);
    } else {
  id = _randomId();
      messages = [];
    }

    final hasSystem = messages.any((m) => m.role == MessageRole.system);
    if (!hasSystem) {
      messages.add(
        const Message(
          role: MessageRole.system,
          content:
              'You are Umbra, a precise and factual AI answer engine. Provide clear, synthesized answers with citations where necessary.',
        ),
      );
    }
    messages.add(Message(role: MessageRole.user, content: question));
    await _save(id, messages);
    yield ConversationStreamEvent.started(id);

    final buffer = StringBuffer();
    List<String> citations = const [];
    await for (final e in _service.streamChat(messages: messages)) {
      if (e.contentDelta != null) {
        buffer.write(e.contentDelta);
        yield ConversationStreamEvent.delta(id, buffer.toString());
      }
      if (e.citations != null) {
        citations = e.citations!;
      }
      if (e.isDone) break;
    }

    messages.add(Message(role: MessageRole.assistant, content: buffer.toString()));
    await _save(id, messages);
    yield ConversationStreamEvent.completed(id, buffer.toString(), citations);
  }
}

class ConversationStreamEvent {
  final String id;
  final String? content;
  final List<String>? citations;
  final bool started;
  final bool completed;

  const ConversationStreamEvent._(this.id,
      {this.content, this.citations, this.started = false, this.completed = false});

  factory ConversationStreamEvent.started(String id) =>
      ConversationStreamEvent._(id, started: true);
  factory ConversationStreamEvent.delta(String id, String content) =>
      ConversationStreamEvent._(id, content: content);
  factory ConversationStreamEvent.completed(
          String id, String content, List<String> citations) =>
      ConversationStreamEvent._(id,
          content: content, citations: citations, completed: true);
}

String _randomId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rng = Random.secure();
  return List.generate(16, (_) => chars[rng.nextInt(chars.length)]).join();
}
