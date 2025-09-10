import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/umbra_logo_compact.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import '../presentation/home_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _go(BuildContext context, int index) {
    if (index == 3) return; // already here
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, _fade(const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, _fade(const ChatScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, _fade(const HistoryScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const UmbraLogoCompact(size: 18)),
      bottomNavigationBar: UmbraBottomNav(currentIndex: 3, onTap: (i) => _go(context, i)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          Text('Pengaturan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _SectionLabel('Model'),
          ListTile(
            title: const Text('Model Default'),
            subtitle: Text('gpt-4o (contoh)', style: TextStyle(color: Colors.white.withOpacity(0.6))),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _SectionLabel('Tampilan'),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Tema Gelap'),
            ),
          const SizedBox(height: 24),
          _SectionLabel('Cache'),
          ListTile(
            title: const Text('Bersihkan Percakapan Lokal'),
            leading: const Icon(Icons.delete_outline),
            onTap: () {},
          ),
          const SizedBox(height: 40),
          Opacity(
            opacity: 0.6,
            child: Text('Versi 0.1.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          )
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 1.5,
              color: Colors.white.withOpacity(0.55),
            ),
      ),
    );
  }
}

PageRouteBuilder _fade(Widget child) => PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, anim, __, c) => FadeTransition(opacity: anim, child: c),
    );
