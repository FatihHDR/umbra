import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../../../widgets/umbra_background.dart';
import '../../../core/language/app_strings.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'sources_screen.dart';
import 'settings_screen.dart';
import '../../../widgets/umbra_logo_compact.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import '../../../utils/fade_nav.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final vm = ref.watch(chatViewModelProvider(null));
  final notifier = ref.read(chatViewModelProvider(null).notifier);
  final t = ref.watch(appStringsProvider);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const UmbraLogoCompact(size: 20),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: t.historyTooltip,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            icon: const Icon(Icons.history_rounded),
          )
        ],
      ),
      bottomNavigationBar: UmbraBottomNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) return;
          switch (i) {
            case 1:
              fadeReplace(context, const ChatScreen());
              break;
            case 2:
              fadeReplace(context, const HistoryScreen());
              break;
            case 3:
              fadeReplace(context, const SourcesScreen());
              break;
            case 4:
              fadeReplace(context, const SettingsScreen());
              break;
          }
        },
      ),
      body: UmbraBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: notifier.setInput,
                    onSubmitted: (_) => _goChat(context, ref),
                    textInputAction: TextInputAction.send,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: t.askHint),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _goChat(context, ref),
                        icon: const Icon(Icons.send),
                        label: Text(t.askButton),
                      ),
                    ],
                  ),
                  if (vm.loading) ...[
                    const SizedBox(height: 24),
                    const _LoadingBar(),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goChat(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
    ref.read(chatViewModelProvider(null).notifier).ask();
  }
}

class _LoadingBar extends StatefulWidget {
  const _LoadingBar();

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

// Removed unused fade helper.

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Align(
          alignment: Alignment(-1.0 + 2 * _c.value, 0),
          child: Container(
            height: 2,
            width: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
