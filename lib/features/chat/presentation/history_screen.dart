import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'sources_screen.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import '../../../core/language/app_strings.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final vm = ref.watch(chatViewModelProvider(null));
    final t = ref.watch(appStringsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.historyTitle),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: UmbraBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 2) return;
          switch (i) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
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
      body: ListView.separated(
        itemCount: vm.history.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = vm.history[i];
          return ListTile(
            title: Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              c.updatedAt.toLocal().toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            onTap: () {
              // rebuild provider bound to the selected conversation id
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

// Removed unused fade helper.
