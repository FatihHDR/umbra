import 'dart:convert';

/// Minimal SSE parser that yields lines starting with 'data:'
/// and decodes JSON payloads for DeepSeek stream events.
class DeepSeekSse {
  DeepSeekSse._();

  static Stream<Map<String, dynamic>> parse(Stream<List<int>> byteStream) async* {
    // Convert bytes to lines
    final lines = byteStream
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final line in lines) {
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith('data:')) {
        final payload = line.substring(5).trim();
        if (payload == "[DONE]") {
          yield {'done': true};
          continue;
        }
        try {
          final obj = jsonDecode(payload) as Map<String, dynamic>;
          yield obj;
        } catch (_) {
          // Ignore malformed JSON chunks
        }
      }
    }
  }
}
