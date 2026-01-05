class Task {
  final String id;
  final String title;        // ชื่อเพลง
  final String artist;      // ศิลปิน
  final String imageUrl;    // 🖼️ รูปปกเพลง
  final DateTime createdAt;
  final bool isCompleted;   // ฟังแล้ว
  final bool isFavorite;    // เพลงโปรด ⭐

  Task({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.isCompleted = false,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Task.create({
    required String title,
    required String artist,
    required String imageUrl,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      artist: artist,
      imageUrl: imageUrl,
    );
  }

  Task copyWith({
    bool? isCompleted,
    bool? isFavorite,
    String? imageUrl,
  }) {
    return Task(
      id: id,
      title: title,
      artist: artist,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }
}
