import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/data/db/notes_database.dart';
import 'package:notes_app/data/model/note.dart';
import 'package:notes_app/presentation/add_edit_note_page.dart';
import 'package:notes_app/presentation/note_details_page.dart';
import 'package:notes_app/widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoading = false;

  late List<Note>? notes;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),

      body: _body(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddEditNotePage())
          );

          refreshNotes();
        },
      ),
    );
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NoteDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  Widget _body() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : notes?.isEmpty == true ?
      Text('No notes',
        style: TextStyle(color: Colors.white),
      ) : _buildNotes(),
    );
  }

  Widget _buildNotes() =>
      StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
          itemCount: notes?.length,
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          itemBuilder: (context, index){
            final note = notes![index];
            return GestureDetector(
              onTap: () async{
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));

                refreshNotes();
              },
              child: NoteCardWidget(
                note: note,
                index: index
              ),
            );
          },
          staggeredTileBuilder: (index) => StaggeredTile.fit(2)
      );
}
