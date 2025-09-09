import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'chat_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(chatViewModelProvider(null));
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Percakapan')),
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
