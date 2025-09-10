import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_provider.dart';

class AppStrings {
  AppStrings(this.code);
  final String code; // 'en' or 'id'
  bool get _en => code == 'en';

  String get askHint => _en ? 'Ask anything...' : 'Tanyakan apapun...';
  String get askButton => _en ? 'Ask' : 'Tanya';
  String get historyTooltip => _en ? 'History' : 'Riwayat';
  String get historyTitle => _en ? 'Conversation History' : 'Riwayat Percakapan';
  String get sourcesTitle => _en ? 'Sources / Documents' : 'Sumber / Dokumen';
  String get sourcesEmpty => _en
      ? 'No sources yet. This feature will list the documents used to answer a question with their metadata.'
      : 'Belum ada daftar sumber. Fitur ini akan menampilkan dokumen yang dipakai untuk menjawab pertanyaan beserta metadata.';
  String get exampleMock => _en ? 'Example (mock)' : 'Contoh (mock)';
  String get settingsTitle => _en ? 'Settings' : 'Pengaturan';
  String get languageSection => _en ? 'Language' : 'Bahasa / Language';
  String get modelSection => 'Model';
  String get modelDefault => _en ? 'Default Model' : 'Model Default';
  String get modelSubtitleExample => _en ? 'gpt-4o (example)' : 'gpt-4o (contoh)';
  String get displaySection => _en ? 'Display' : 'Tampilan';
  String get darkTheme => _en ? 'Dark Theme' : 'Tema Gelap';
  String get cacheSection => 'Cache';
  String get clearLocalConversations => _en ? 'Clear Local Conversations' : 'Bersihkan Percakapan Lokal';
  String get versionLabel => _en ? 'Version' : 'Versi';
  String get english => 'English';
  String get indonesian => _en ? 'Indonesian' : 'Indonesia';
}

final appStringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(languageProvider);
  return AppStrings(lang);
});