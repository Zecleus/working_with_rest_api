import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/services/notes_service.dart';
// ignore_for_file: prefer_const_constructors

import 'views/note_list.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
