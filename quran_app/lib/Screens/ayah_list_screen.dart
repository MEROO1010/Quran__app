import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Screens/bookmark_screen.dart';
import 'package:quran_app/providers/quran_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class AyahListScreen extends StatelessWidget {
  final int surahNumber;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AyahListScreen({required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ayahs'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String language) {
              quranProvider.setSelectedLanguage(language);
              quranProvider.fetchAyahs(surahNumber);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'ar', child: Text('Arabic')),
                // Add more languages here
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: quranProvider.fetchAyahs(surahNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: quranProvider.ayahs.length,
              itemBuilder: (context, index) {
                final ayah = quranProvider.ayahs[index];
                final isBookmarked = quranProvider.bookmarks.contains(ayah);

                return ListTile(
                  title: Text(ayah.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        onPressed: () {
                          if (isBookmarked) {
                            quranProvider.removeBookmark(ayah);
                          } else {
                            quranProvider.addBookmark(ayah);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () async {
                          try {
                            final audioUrl = await quranProvider.fetchAudioUrl(
                              ayah.number,
                            ); // Ensure ayah.number is an integer
                            await _audioPlayer.play(audioUrl as Source);
                          } catch (e) {
                            print('Error playing audio: $e');
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.book),
                        onPressed: () async {
                          try {
                            final tafsir = await quranProvider.fetchTafsir(
                              surahNumber,
                              ayah.number,
                            ); // Ensure ayah.number is an integer
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text('Tafsir'),
                                    content: Text(tafsir),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                            );
                          } catch (e) {
                            print('Error fetching tafsir: $e');
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
