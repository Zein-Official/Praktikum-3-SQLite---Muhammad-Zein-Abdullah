class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Konversi objek Note menjadi Map untuk disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Konversi Map dari database menjadi objek Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
