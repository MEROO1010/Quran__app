import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks')),
      body: ListView.builder(
        itemCount: quranProvider.bookmarks.length,
        itemBuilder: (context, index) {
          final ayah = quranProvider.bookmarks[index];
          return ListTile(
            title: Text(ayah.text),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                quranProvider.removeBookmark(ayah);
              },
            ),
          );
        },
      ),
    );
  }
}
