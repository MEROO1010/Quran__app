import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: quranProvider.isDarkMode,
              onChanged: (value) {
                quranProvider.toggleDarkMode();
              },
            ),
            ListTile(
              title: Text('Font Size'),
              trailing: DropdownButton<double>(
                value: quranProvider.fontSize,
                items:
                    [14.0, 16.0, 18.0, 20.0].map((size) {
                      return DropdownMenuItem<double>(
                        value: size,
                        child: Text(size.toString()),
                      );
                    }).toList(),
                onChanged: (value) {
                  quranProvider.setFontSize(value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
