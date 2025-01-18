import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quran_app/models/quran_model.dart';

class QuranService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String audioBaseUrl =
      'https://api.quran.com/api/v4/quran/verses/audio';
  static const String tafsirBaseUrl = 'https://api.quran.com/api/v3';

  Future<List<Surah>> fetchSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  Future<List<Ayah>> fetchAyahs(
    int surahNumber, {
    String language = 'en',
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$surahNumber/$language'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['ayahs'];
      return data.map((json) => Ayah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Ayahs');
    }
  }

  Future<String> fetchAudioUrl(int ayahNumber) async {
    final response = await http.get(
      Uri.parse('$audioBaseUrl?verse_key=$ayahNumber'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['audio_url'];
    } else {
      throw Exception('Failed to load audio');
    }
  }

  Future<String> fetchTafsir(int surahNumber, int ayahNumber) async {
    final response = await http.get(
      Uri.parse(
        '$tafsirBaseUrl/tafsir?chapter_id=$surahNumber&verse_id=$ayahNumber',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['text'];
    } else {
      throw Exception('Failed to load tafsir');
    }
  }
}
