import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/language/app_strings.dart';
import '../../../widgets/umbra_bottom_nav.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'sources_screen.dart';
import '../../../core/language/language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final t = ref.watch(appStringsProvider);
    return Scaffold(
      bottomNavigationBar: UmbraBottomNav(
        currentIndex: 4,
        onTap: (i) {
          if (i == 4) return;
          switch (i) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
              break;
            case 3:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SourcesScreen()));
              break;
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          Text(t.settingsTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _SectionLabel(t.languageSection),
          Consumer(builder: (context, ref, _) {
            final current = ref.watch(languageProvider);
            final notifier = ref.read(languageProvider.notifier);
            return Column(
              children: [
                RadioListTile<String>(
                  value: 'en',
                  groupValue: current,
                  onChanged: (v) => notifier.setLanguage(v!),
                  title: Text(t.english),
                  dense: true,
                ),
                RadioListTile<String>(
                  value: 'id',
                  groupValue: current,
                  onChanged: (v) => notifier.setLanguage(v!),
                  title: Text(t.indonesian),
                  dense: true,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          _SectionLabel(t.modelSection),
          ListTile(
            title: Text(t.modelDefault),
            subtitle: Text(t.modelSubtitleExample, style: TextStyle(color: Colors.white.withOpacity(0.6))),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _SectionLabel(t.displaySection),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: Text(t.darkTheme),
            ),
          const SizedBox(height: 24),
          _SectionLabel(t.cacheSection),
          ListTile(
            title: Text(t.clearLocalConversations),
            leading: const Icon(Icons.delete_outline),
            onTap: () {},
          ),
          const SizedBox(height: 40),
          Opacity(
            opacity: 0.6,
            child: Text('${t.versionLabel} 0.1.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
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

// Removed unused fade helper.
