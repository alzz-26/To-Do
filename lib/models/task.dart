class Task {
  final int id;
  final String title;
  final String description;
  bool completed;

  Task({required this.id, required this.title, required this.description, required this.completed});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
  };
}
