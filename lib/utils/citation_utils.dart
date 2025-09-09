import 'package:flutter/painting.dart';

TextStyle citationStyle(Color color) =>
		TextStyle(color: color, fontWeight: FontWeight.w600);

/// Replace occurrences of [1], [12], etc. with Markdown links
/// like [1](citation://1) so we can intercept taps.
String linkifyCitations(String text) {
	final regex = RegExp(r"\[(\d+)\]");
	return text.replaceAllMapped(regex, (m) {
		final n = m.group(1);
		return '[${n}](citation://${n})';
	});
}
