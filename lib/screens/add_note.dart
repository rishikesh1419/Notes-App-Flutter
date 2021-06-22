import 'package:flutter/material.dart';
import 'package:notes_app/db/db_provider.dart';
import 'package:notes_app/models/note_model.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String body;
  late DateTime creationDate;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(NoteModel note) {
    DbProvider.db.addNote(note);
    print("Note saved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save"),
        icon: Icon(Icons.save),
        onPressed: () {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            creationDate = DateTime.now();
          });
          NoteModel note = NoteModel(
            title: title,
            body: body,
            creationDate: creationDate,
          );
          addNote(note);
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        },
      ),
    );
  }
}
