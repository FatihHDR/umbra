import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../../../utils/citation_utils.dart';
import '../../../utils/code_syntax_highlighter.dart';
import '../../../widgets/umbra_background.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatViewModelProvider(null));
    final notifier = ref.read(chatViewModelProvider(null).notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Percakapan'),
      ),
      body: UmbraBackground(
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.error != null) ...[
                    Text(state.error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                  ],
                  if (state.answer.isNotEmpty)
                    MarkdownBody(
                      data: linkifyCitations(state.answer),
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(color: Colors.white),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        blockquoteDecoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: Border(left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)),
                        ),
                      ),
                      syntaxHighlighter: CodeSyntaxHighlighter(),
                      onTapLink: (text, href, title) {
                        if (href != null && href.startsWith('citation://')) {
                          final idx = int.tryParse(href.split('://').last);
                          if (idx != null && idx > 0 && idx <= state.citations.length) {
                            _showCitations(context, state.citations);
                          }
                        }
                      },
                    ),
                  if (state.citations.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (int i = 0; i < state.citations.length; i++)
                          ActionChip(
                            label: Text('[${i + 1}]', style: const TextStyle(color: Colors.white)),
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            onPressed: () => _showCitations(context, state.citations),
                          ),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
          _Composer(onSend: notifier.ask, onChanged: notifier.setInput, loading: state.loading),
        ],
        ),
      ),
    );
  }

  void _showCitations(BuildContext context, List<String> citations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: citations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => ListTile(
              title: Text('Sumber [${i + 1}]', style: const TextStyle(color: Colors.white)),
              subtitle: Text(citations[i], style: TextStyle(color: Colors.white.withOpacity(0.8))),
            ),
          ),
        );
      },
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.onSend, required this.onChanged, required this.loading});
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(hintText: 'Tanyakan apapun...'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: loading ? null : onSend,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
