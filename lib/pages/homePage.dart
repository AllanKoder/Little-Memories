import 'dart:async';
import 'dart:io';

import 'package:birthday/components/appBar.dart';
import 'package:birthday/helper/dateInformation.dart';
import 'package:birthday/helper/entryData.dart';
import 'package:birthday/pages/newEntryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String countdownMessage = "";
  late Timer _timer;
  Future<List<Map<String, dynamic>>>? _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = LoadEntries();
    calculateCountdown();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => calculateCountdown());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void calculateCountdown() {
    countdownMessage = AnniversaryCountDown();
    setState(() {});
  }

  ListView entryList(entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          title: Container(
            width: 200,
            child: Text(
              "${entry['title']}",
              style: const TextStyle(
                fontSize: 16,
              ),
              softWrap: true,
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateStringToDisplayFormat(entry['date']),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(entry['description']),
            ],
          ),
          leading:
              entry['image'] != null ? Image.file(File(entry['image'])) : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text(
                        'Are you sure you want to delete this entry?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () async {
                          // Add your delete logic here
                          // For example, you can remove the entry from your entries list
                          await DeleteEntry(entry);
                          _entriesFuture = LoadEntries();

                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar("Little Memories"),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.pink[100],
            ),
            child: Text(countdownMessage),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              String entries = await LoadEntriesWithoutImage();
              Clipboard.setData(ClipboardData(text: entries));
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _entriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return const Text('No data');
                } else {
                  final entries = snapshot.data!;
                  return entryList(entries);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createEntry(context);
        },
        backgroundColor: Colors.pink[200],
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> createEntry(BuildContext context) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewEntryScreen()),
    );
    if (result) _entriesFuture = LoadEntries();
  }
}
