import 'dart:convert';

import 'package:working_with_rest_api/models/api_response.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

import '../models/note.dart';

class NotesService {
  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    // ignore: constant_identifier_names
    const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
    const headers = {'apiKey': 'b9572336-5f82-427f-a303-cbe7c92c8611'};

    // ignore: prefer_interpolation_to_compose_strings
    return http.get(Uri.parse(API + '/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];

        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    // ignore: constant_identifier_names
    const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
    const headers = {'apiKey': 'b9572336-5f82-427f-a303-cbe7c92c8611'};

    return http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse(API + '/notes/' + noteID), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }
}
