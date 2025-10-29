import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final VoidCallback onSave;

  const NoteForm({super.key, this.note, required this.onSave});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      if (widget.note == null) {
        // Tambah catatan baru
        await DatabaseHelper.instance.insert(Note(title: title, content: content));
      } else {
        // Update catatan yang ada
        await DatabaseHelper.instance.update(
          Note(id: widget.note!.id, title: title, content: content),
        );
      }

      widget.onSave();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
        backgroundColor: const Color.fromARGB(255, 250, 127, 27),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Isi catatan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
