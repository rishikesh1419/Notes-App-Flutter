import 'package:flutter/material.dart';
import 'package:notes_app/db/db_provider.dart';
import 'package:notes_app/screens/add_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/new": (context) => AddNote(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getNotes() async {
    final notes = await DbProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Notes"),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, noteData) {
          switch (noteData.connectionState) {
            case ConnectionState.waiting:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                if (noteData.data == Null) {
                  return Center(
                    child: Text("Create your first note!"),
                  );
                } else {
                  List<Map<String, dynamic>> data =
                      noteData.data as List<Map<String, dynamic>>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String title = data[index]["title"];
                        String body = data[index]["body"];
                        String creationDate =
                            data[index]["creationDate"].toString();
                        int? id = data[index]["id"];

                        return Card(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(body),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            case ConnectionState.none:
              return Center(
                child: Text("Something"),
              );
            case ConnectionState.active:
              return Center(
                child: Text("Something"),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: () {
          Navigator.pushNamed(context, "/new");
        },
      ),
    );
  }
}
