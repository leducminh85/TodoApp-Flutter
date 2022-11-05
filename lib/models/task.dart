class Task {
  final int? id;
  final String? title;
  final String? description;
  final int? status;

  Task({this.id, this.title, this.description, this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
    };
  }
}
