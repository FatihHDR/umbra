import 'dart:convert';

/// SSE parser for DeepSeek style event stream.
/// Avoids generic type issues by manually decoding chunks.
class DeepSeekSse {
  DeepSeekSse._();

  static Stream<Map<String, dynamic>> parse(Stream<List<int>> byteStream) async* {
    final buffer = StringBuffer();

    List<Map<String, dynamic>> drainBuffer({bool forceAll = false}) {
      final text = buffer.toString();
      if (text.isEmpty) return const [];
      final lines = text.split(RegExp(r'\r?\n'));
      final events = <Map<String, dynamic>>[];
      if (lines.isEmpty) return events;
      final lastLineComplete = text.endsWith('\n') || text.endsWith('\r');
      int endIndex = lines.length;
      if (!lastLineComplete && !forceAll) {
        endIndex -= 1; // keep last partial
      }
      for (var i = 0; i < endIndex; i++) {
        final l = lines[i];
        if (l.isEmpty) continue;
        final parsed = _parseLine(l);
        if (parsed != null) events.add(parsed);
      }
      final trailing = (!lastLineComplete && !forceAll) ? lines.last : '';
      buffer
        ..clear()
        ..write(trailing);
      return events;
    }

    await for (final raw in byteStream) {
      buffer.write(utf8.decode(raw));
      if (buffer.toString().contains('\n')) {
        for (final e in drainBuffer()) {
          yield e;
        }
      }
    }
    // Flush all remaining (force including partial)
    for (final e in drainBuffer(forceAll: true)) {
      yield e;
    }
  }

  static Map<String, dynamic>? _parseLine(String line) {
    if (!line.startsWith('data:')) return null;
    final payload = line.substring(5).trim();
    if (payload == '[DONE]') return {'done': true};
    try {
      final obj = jsonDecode(payload);
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {
      // ignore malformed
    }
    return null;
  }
}
