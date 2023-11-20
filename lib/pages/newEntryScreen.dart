import 'dart:convert';
import 'dart:io';

import 'package:birthday/components/appBar.dart';
import 'package:birthday/helper/entryData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  // ...
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Diary Entry"),
          backgroundColor: Colors.pink[400],
          elevation: 0.0,
          leading: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                Navigator.pop(context),
              },
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _image != null
                  ? Image.file(
                      File(_image!.path),
                      height: 200,
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 80.0,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.pink),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      NewEntry entry =
                          NewEntry(_title, _description, _image?.path);
                      bool result = await SaveEntry(entry);

                      Navigator.pop(context, result);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickImage,
          backgroundColor: Colors.pink[200],
          child: const Icon(Icons.add_photo_alternate),
        ),
      ),
    );
  }
}
