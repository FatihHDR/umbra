# Umbra — AI Answer Engine (Flutter)

Umbra adalah aplikasi mobile AI Answer Engine premium. Fokus pada jawaban yang akurat, ringkas, dan bersumber jelas. Dibangun dengan Flutter (iOS & Android), arsitektur MVVM + Riverpod, networking via Dio (SSE), dan penyimpanan lokal menggunakan Hive.

## Fitur
- Home minimalis bertema gelap (#121212) dengan aksen merah (#FF3B30)
- Chat Screen dengan streaming jawaban real-time (animasi ketik) via SSE
- Dukungan Markdown (tebal/miring, daftar, blok kode)
- Sitasi [1], [2], ... yang bisa diklik untuk melihat sumber pada bottom sheet
- Riwayat percakapan lokal (Hive)

## Setup
1) Prasyarat: Flutter stable terbaru.
2) Salin file env contoh dan isi API key DeepSeek:

```
copy .env.example .env
```

Buka file `.env` dan set:

```
DEEPSEEK_API_KEY=your_api_key_here
```

3) Jalankan:

```
flutter pub get
flutter run
```

## Catatan
- Kunci API tidak di-hardcode. Gunakan `.env` (flutter_dotenv) dan jangan commit file `.env`.
- Endpoint yang digunakan: https://api.deepseek.com/v1/chat/completions dengan stream: true.
- SSE diparsing dari `text/event-stream` menggunakan util sederhana di `lib/utils/sse_parser.dart`.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
