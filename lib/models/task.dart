class Task {
  final int? id;
  final String? title;
  final String? description;
  final int? status;
  final String? deadline;
  final int? noti;

  Task({this.id, this.title, this.description, this.status, this.deadline, this.noti});

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
