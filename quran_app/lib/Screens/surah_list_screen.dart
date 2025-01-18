import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Screens/ayah_list_screen.dart';
import '../providers/quran_provider.dart';

class SurahListScreen extends StatefulWidget {
  @override
  _SurahListScreenState createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quran App'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Surahs or Ayahs...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                  quranProvider.searchAyahs(_searchQuery);
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: quranProvider.fetchSurahs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || quranProvider.surahs.isEmpty) {
            return Center(child: Text('No Surahs found'));
          } else {
            final filteredSurahs =
                quranProvider.surahs.where((surah) {
                  return surah.englishName.toLowerCase().contains(_searchQuery);
                }).toList();

            final searchResults = quranProvider.searchResults;

            return ListView.builder(
              itemCount: filteredSurahs.length + searchResults.length,
              itemBuilder: (context, index) {
                if (index < filteredSurahs.length) {
                  final surah = filteredSurahs[index];
                  return ListTile(
                    title: Text(surah.englishName),
                    subtitle: Text(surah.englishNameTranslation),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  AyahListScreen(surahNumber: surah.number),
                        ),
                      );
                    },
                  );
                } else {
                  final ayah = searchResults[index - filteredSurahs.length];
                  return ListTile(
                    title: Text(ayah.text),
                    subtitle: Text(
                      'Surah: ${ayah.surahNumber}, Ayah: ${ayah.number}',
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
