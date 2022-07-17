import 'package:app_notes/models/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';

class AddOrDetailScreen extends StatefulWidget {
  // const AddOrDetailScreen({Key key}) : super(key: key);
  static const routeName = '/addOrDetailScreen';

  @override
  State<AddOrDetailScreen> createState() => _AddOrDetailScreenState();
}

class _AddOrDetailScreenState extends State<AddOrDetailScreen> {
  Note _note = Note(
    id: null,
    title: '',
    note: '',
    updatedAt: null,
    createdAt: null,
  );

  bool _init = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void submitNote() async {
    // dijalankan dan onSave di jalankan
    _formKey.currentState.save();

    //set loading true
    setState(() {
      _isLoading = true;
    });

    try {
      //update time updated at
      final now = DateTime.now();
      _note = _note.copyWith(updatedAt: now, createdAt: now);
      // tidak melistern perubahan di note hanya menambahkan note
      final notesProvider = Provider.of<Notes>(context, listen: false);
      // cek jika id no null
      if (_note.id == null) {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              e.toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Tutup'),
              )
            ],
          );
        },
      );
    }
    Navigator.of(context).pop();

    // print('title :' + _note.title);
    // print(_note.note);
  }

  // beberapa kali di jalanin klo ini state cuma 1 kali di jalanin
  @override
  void didChangeDependencies() {
    // mencari berdasarkan id
    if (_init) {
      String id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) _note = Provider.of<Notes>(context).getNote(id);
      _init = false;
    }
    super.didChangeDependencies();
  }

  // function convert date
  String _convertDate(DateTime dateTime) {
    // mengambil waktu sekarang dan perbedaan dlm hari
    int diff = DateTime.now().difference(dateTime).inDays;
    if (diff > 0) //lebih sehari
      return DateFormat('dd-MM-yyyy').format(dateTime);

    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: submitNote,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _note.title,
                      decoration: InputDecoration(
                        hintText: 'Judul',
                        border: InputBorder.none,
                      ),
                      onSaved: (newValue) {
                        _note = _note.copyWith(title: newValue);
                      },
                    ),
                    TextFormField(
                      initialValue: _note.note,
                      decoration: InputDecoration(
                        hintText: 'Tulis catatan disini...',
                        border: InputBorder.none,
                      ),
                      onSaved: (newValue) {
                        _note = _note.copyWith(note: newValue);
                      },
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_note.updatedAt != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: Text('Terakhir diubah ${_convertDate(_note.updatedAt)}'),
            ),
        ],
      ),
    );
  }
}
