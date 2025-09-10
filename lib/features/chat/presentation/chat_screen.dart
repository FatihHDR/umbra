import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../../../utils/citation_utils.dart';
import '../../../utils/code_syntax_highlighter.dart';
import '../../../widgets/umbra_background.dart';
import '../../../core/language/app_strings.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'sources_screen.dart';
import 'settings_screen.dart';
import '../../../widgets/umbra_logo_compact.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(chatViewModelProvider(null));
  final notifier = ref.read(chatViewModelProvider(null).notifier);
  final t = ref.watch(appStringsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const UmbraLogoCompact(size: 18),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: UmbraBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 1) return;
          switch (i) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
              break;
            case 3:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SourcesScreen()));
              break;
            case 4:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              break;
          }
        },
      ),
      body: UmbraBackground(
        child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.messages.length + (state.loading ? 1 : 0),
              reverse: false,
              itemBuilder: (context, index) {
                if (index >= state.messages.length) {
                  return const _TypingBubble();
                }
                final msg = state.messages[index];
                final isUser = msg.role.name == 'user';
                final bubbleColor = isUser
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                    : const Color(0xFF1E1E20);
                final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final radius = BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                );
                Widget content;
                if (msg.role.name == 'assistant') {
                  content = MarkdownBody(
                    data: linkifyCitations(msg.content),
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
                  );
                } else {
                  content = Text(
                    msg.content,
                    style: const TextStyle(color: Colors.white),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: align,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: radius,
                          border: Border.all(
                            color: isUser
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.35)
                                : Colors.white.withOpacity(0.06),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: content,
                      ),
                      if (index == state.messages.length - 1 && state.citations.isNotEmpty && msg.role.name == 'assistant')
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              for (int i = 0; i < state.citations.length; i++)
                                GestureDetector(
                                  onTap: () => _showCitations(context, state.citations),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.16),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('[${i + 1}]', style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          _Composer(onSend: notifier.ask, onChanged: notifier.setInput, loading: state.loading, hint: t.askHint),
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
  const _Composer({required this.onSend, required this.onChanged, required this.loading, required this.hint});
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;
  final bool loading;
  final String hint;

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
                decoration: InputDecoration(hintText: hint),
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

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E20),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = _c.value;
            int active = (t * 3).floor() % 3;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: i == active ? 1.0 : 0.35,
                    child: const CircleAvatar(radius: 3, backgroundColor: Colors.white),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
