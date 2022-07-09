import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/models/api_response.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:working_with_rest_api/services/notes_service.dart';
import 'package:working_with_rest_api/views/note_delete.dart';

import 'note_modify.dart';
// ignore_for_file: prefer_const_constructors

class NoteList extends StatefulWidget {
  NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.instance<NotesService>();
  APIResponse<List<NoteForListing>>? _apiResponse;
  bool _isLoading = false;
  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => NoteModify(),
            ),
          )
              .then((_) {
            _fetchNotes();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_apiResponse!.error!) {
            return Center(
              child: Text(_apiResponse!.errorMessage!),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.green,
            ),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse!.data![index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                      context: context, builder: (_) => NoteDelete());

                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _apiResponse!.data![index].noteTitle!,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                      'Last edited on ${formatDateTime(_apiResponse!.data![index].latestEditDateTime ?? _apiResponse!.data![index].createDateTime!)}'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NoteModify(
                            noteID: _apiResponse!.data![index].noteID)));
                  },
                ),
              );
            },
            itemCount: _apiResponse!.data!.length,
          );
        },
      ),
    );
  }
}
