import 'package:app_notes/widgets/note_item.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';

class NotesGrid extends StatefulWidget {
  // const NotesGrid({Key key}) : super(key: key);

  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context);
    List<Note> listNote = notesProvider.notes;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: listNote.length,
        itemBuilder: (context, index) => NoteItem(
          id: listNote[index].id,
          ctx: context,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      ),
    );
  }
}
