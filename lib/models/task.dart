class Task {
  final int? id;
  final String? title;
  final String? description;
  final int? status;
  final String? deadline;

  Task({this.id, this.title, this.description, this.status, this.deadline});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'deadline': deadline
    };
  }
}
