import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quran_model.dart';
import '../services/quran_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QuranProvider extends ChangeNotifier {
  final QuranService _quranService = QuranService();
  List<Surah> _surahs = [];
  List<Ayah> _ayahs = [];
  List<Ayah> _bookmarks = [];
  List<Ayah> _searchResults = [];
  String _selectedLanguage = 'en';
  bool _isDarkMode = false;
  double _fontSize = 16.0;

  List<Surah> get surahs => _surahs;
  List<Ayah> get ayahs => _ayahs;
  List<Ayah> get bookmarks => _bookmarks;
  List<Ayah> get searchResults => _searchResults;
  String get selectedLanguage => _selectedLanguage;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  QuranProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    var box = await Hive.openBox('quran');
    _surahs = box.get('surahs', defaultValue: []);
    _ayahs = box.get('ayahs', defaultValue: []);
    _bookmarks = box.get('bookmarks', defaultValue: []);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    notifyListeners();
  }

  Future<void> fetchSurahs() async {
    _surahs = await _quranService.fetchSurahs();
    var box = await Hive.openBox('quran');
    box.put('surahs', _surahs);
    notifyListeners();
  }

  Future<void> fetchAyahs(int surahNumber) async {
    _ayahs = await _quranService.fetchAyahs(
      surahNumber,
      language: _selectedLanguage,
    );
    var box = await Hive.openBox('quran');
    box.put('ayahs', _ayahs);
    notifyListeners();
  }

  Future<void> searchAyahs(String query) async {
    _searchResults = _ayahs.where((ayah) => ayah.text.contains(query)).toList();
    notifyListeners();
  }

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  Future<void> addBookmark(Ayah ayah) async {
    _bookmarks.add(ayah);
    var box = await Hive.openBox('quran');
    box.put('bookmarks', _bookmarks);
    notifyListeners();
  }

  Future<void> removeBookmark(Ayah ayah) async {
    _bookmarks.remove(ayah);
    var box = await Hive.openBox('quran');
    box.put('bookmarks', _bookmarks);
    notifyListeners();
  }

  Future<String> fetchAudioUrl(int ayahNumber) async {
    // Implement the logic to fetch the audio URL for the given ayah number

    // For example:

    return 'https://example.com/audio/$ayahNumber.mp3';
  }

  Future<String> fetchTafsir(int surahNumber, int ayahNumber) async {
    // Implement the logic to fetch tafsir here

    // For example, you can make an API call to get the tafsir

    // and return the result as a string.

    return 'Sample tafsir for Surah $surahNumber, Ayah $ayahNumber';
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setFontSize(double size) async {
    _fontSize = size;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', _fontSize);
    notifyListeners();
  }
}
