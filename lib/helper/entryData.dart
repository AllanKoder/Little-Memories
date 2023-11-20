import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> LoadEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final entries = <Map<String, dynamic>>[];
  prefs.getKeys().forEach((key) {
    if (key.startsWith('entry_')) {
      entries.add(jsonDecode(prefs.getString(key) ?? '{}'));
    }
  });
  entries.sort((a, b) {
    DateTime dateA = DateTime.parse(a['date']);
    DateTime dateB = DateTime.parse(b['date']);
    return dateB.compareTo(dateA);
  });

  return entries;
}

Future<void> DeleteEntry(entry) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(entry['id']);
}

class NewEntry {
  String? title;
  String? description;
  String? imagePath;
  NewEntry(this.title, this.description, this.imagePath);
}

Future<bool> SaveEntry(NewEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  final entryId = now.millisecondsSinceEpoch.toString();
  await prefs.setString(
      'entry_$entryId',
      jsonEncode({
        'title': entry.title,
        'description': entry.description,
        'image': entry.imagePath,
        'date': now.toString(),
        'id': 'entry_$entryId',
      }));
  return true;
}

Future<String> LoadEntriesWithoutImage() async {
  var entries = <Map<String, dynamic>>[];
  entries = await LoadEntries();

  String formattedEntries = '';
  for (var entry in entries) {
    formattedEntries +=
        'Title - ${entry['title']}\nDate - ${entry['date']}\nDescription\n${entry['description']}\n\n';
  }

  return formattedEntries;
}
