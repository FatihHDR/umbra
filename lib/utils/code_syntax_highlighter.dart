import 'package:flutter/painting.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart' as hl;

class CodeSyntaxHighlighter extends SyntaxHighlighter {
  final String language;
  CodeSyntaxHighlighter({this.language = 'dart'});

  @override
  TextSpan format(String source) {
    final nodes = hl.highlight.parse(source, language: language).nodes ?? [];
    final children = <TextSpan>[];
    for (final node in nodes) {
      if (node.value != null) {
        children.add(TextSpan(text: node.value));
      } else if (node.children != null) {
        children.add(TextSpan(children: _convert(node.children!)));
      }
    }
    return TextSpan(style: const TextStyle(fontFamily: 'monospace'), children: children);
  }

  List<TextSpan> _convert(List<hl.Node> nodes) {
    final spans = <TextSpan>[];
    for (final node in nodes) {
      final style = _styleFor(node.className);
      if (node.value != null) {
        spans.add(TextSpan(text: node.value, style: style));
      } else if (node.children != null) {
        spans.add(TextSpan(style: style, children: _convert(node.children!)));
      }
    }
    return spans;
  }

  TextStyle? _styleFor(String? className) {
    if (className == null) return null;
    switch (className) {
      case 'keyword':
      case 'built_in':
        return const TextStyle(color: Color(0xFFFF3B30));
      case 'string':
        return const TextStyle(color: Color(0xFF34C759));
      case 'number':
        return const TextStyle(color: Color(0xFF5AC8FA));
      case 'comment':
        return TextStyle(color: const Color(0xFFFFFFFF).withOpacity(0.5), fontStyle: FontStyle.italic);
      default:
        return null;
    }
  }
}
