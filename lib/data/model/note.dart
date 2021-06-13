final String tableNotes = 'notes';

class NoteColumn {
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';

  static List<String> columns = [
    id, isImportant, number, title, description, time
  ];
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
          id: id ?? this.id,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);

  Map<String, Object?> toJson() => {
        NoteColumn.id: id,
        NoteColumn.title: title,
        NoteColumn.isImportant: isImportant ? 1 : 0,
        NoteColumn.number: number,
        NoteColumn.description: description,
        NoteColumn.time: createdTime.toIso8601String()
      };

  static Note fromJson(Map<String, Object?> maps) => Note(
    id: maps[NoteColumn.id] as int?,
    number: maps[NoteColumn.number] as int,
    title: maps[NoteColumn.title] as String,
    description: maps[NoteColumn.description] as String,
    createdTime: DateTime.parse(maps[NoteColumn.time] as String),
    isImportant: maps[NoteColumn.isImportant] == 1
  );
}
