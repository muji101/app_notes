import 'package:app_notes/models/note.dart';
import 'package:app_notes/providers/notes.dart';
import 'package:app_notes/screens/add_or_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteItem extends StatefulWidget {
  // const NoteItem({Key key}) : super(key: key);
  final String id;
  final BuildContext ctx;

  NoteItem({
    @required this.id,
    @required this.ctx,
  });

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context, listen: false);
    Note note = notesProvider.getNote(widget.id);

    return Dismissible(
      // hilang ketika di swap
      key: Key(note.id),
      onDismissed: (direction) {
        // catch error
        notesProvider.deleteNote(note.id).catchError((onError) {
          ScaffoldMessenger.of(widget.ctx)
              .clearSnackBars(); // menghapus snackbar tanpa menunggu
          ScaffoldMessenger.of(widget.ctx)
              .showSnackBar(SnackBar(content: Text(onError.toString())));
        });
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          AddOrDetailScreen.routeName,
          // mengambil id
          arguments: note.id,
        ),
        child: GridTile(
          header: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  notesProvider.toggleIsPinned(note.id).catchError((onError) {
                    ScaffoldMessenger.of(widget.ctx)
                        .clearSnackBars(); // menghapus snackbar tanpa menunggu
                    ScaffoldMessenger.of(widget.ctx).showSnackBar(
                        SnackBar(content: Text(onError.toString())));
                  });
                },
                icon: Icon(
                    note.isPinned ? Icons.pin_drop : Icons.pin_drop_outlined)),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[800]),
            child: Text(note.note),
            padding: EdgeInsets.all(12),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            child: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(note.title),
            ),
          ),
        ),
      ),
    );
  }
}
