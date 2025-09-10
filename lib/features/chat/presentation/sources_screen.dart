import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/language/app_strings.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../../../utils/fade_nav.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appStringsProvider);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(t.sourcesTitle),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: UmbraBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 3) return;
          switch (i) {
            case 0:
              fadeScaleReplace(context, const HomeScreen());
              break;
            case 1:
              fadeScaleReplace(context, const ChatScreen());
              break;
            case 2:
              fadeScaleReplace(context, const HistoryScreen());
              break;
            case 4:
              fadeScaleReplace(context, const SettingsScreen());
              break;
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Text(t.sourcesTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Opacity(opacity: 0.65, child: Text(t.sourcesEmpty)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              color: const Color(0xFF1E1E20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.exampleMock, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _SourceTile(title: 'paper_llm_context.pdf', snippet: '...retrieval augmented generation improves factuality...'),
                const Divider(height: 20),
                _SourceTile(title: 'docs/api_reference.md', snippet: '...Authentication: Use the provided API key header...'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.title, required this.snippet});
  final String title;
  final String snippet;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Opacity(opacity: 0.7, child: Text(snippet, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}

  // Removed unused fade helper.