import 'dart:convert';

import 'package:working_with_rest_api/models/api_response.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {
  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
    const headers = {'apiKey': 'b9572336-5f82-427f-a303-cbe7c92c8611'};

    return http.get(Uri.parse(API + '/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];

        for (var item in jsonData) {
          final note = NoteForListing(
            noteID: item['noteID'],
            noteTitle: item['noteTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          notes.add(note);
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured'));
  }
}
