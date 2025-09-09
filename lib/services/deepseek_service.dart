import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/message.dart';
import '../utils/sse_parser.dart';

class DeepSeekService {
  DeepSeekService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _endpoint = 'https://api.deepseek.com/v1/chat/completions';

  Stream<DeepSeekStreamEvent> streamChat({
    required List<Message> messages,
  }) async* {
    final key = dotenv.env['DEEPSEEK_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('DEEPSEEK_API_KEY is missing. Add it to .env');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $key',
      'Accept': 'text/event-stream',
    };

    final body = {
      'model': 'deepseek-chat',
      'messages': messages.map((m) => m.toJson()).toList(),
      'stream': true,
    };

    final resp = await _dio.post<ResponseBody>(
      _endpoint,
      data: body,
      options: Options(
        headers: headers,
        responseType: ResponseType.stream,
      ),
    );

    final stream = resp.data!.stream;
    await for (final obj in DeepSeekSse.parse(stream)) {
      if (obj['done'] == true) {
        yield const DeepSeekStreamEvent.done();
        continue;
      }
      // DeepSeek format assumed similar to OpenAI: choices[0].delta.content
      final choices = obj['choices'] as List<dynamic>?;
      final delta = choices != null && choices.isNotEmpty
          ? (choices.first['delta'] as Map?)
          : null;
      final content = delta != null ? (delta['content'] as String?) : null;
      // Citations: non-standard, expect 'citations' list when finish
      final citations = (obj['citations'] as List?)?.cast<String>();
      if (content != null && content.isNotEmpty) {
        yield DeepSeekStreamEvent.delta(content);
      }
      if (citations != null) {
        yield DeepSeekStreamEvent.citations(citations);
      }
    }
  }
}

class DeepSeekStreamEvent {
  final String? contentDelta;
  final List<String>? citations;
  final bool isDone;

  const DeepSeekStreamEvent._({
    this.contentDelta,
    this.citations,
    this.isDone = false,
  });

  const DeepSeekStreamEvent.delta(String delta)
      : this._(contentDelta: delta);
  const DeepSeekStreamEvent.citations(List<String> citations)
      : this._(citations: citations);
  const DeepSeekStreamEvent.done() : this._(isDone: true);
}
