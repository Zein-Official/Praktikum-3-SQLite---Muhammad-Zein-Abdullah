import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';
import 'note_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
void initState() {
  super.initState();
  _loadNotes(); // ini wajib
}

  // Membaca data dari database
  void _loadNotes() async {
    notes = await DatabaseHelper.instance.readAllNotes();
    setState(() {});
  }

  // Menghapus catatan
  void _delete(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadNotes();
  }

  // Pindah ke form tambah/edit catatan
  void _navigateToForm({Note? note}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteForm(
          note: note,
          onSave: _loadNotes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Catatan'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: notes.isEmpty
          ? const Center(child: Text('Belum ada catatan'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(note.id!),
                    ),
                    onTap: () => _navigateToForm(note: note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }
}
