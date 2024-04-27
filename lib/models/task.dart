class Task {
  int? id;
  String? name;
  String? description;
  DateTime? date;
  String? priority;
  int? status;

  Task(
      {this.id,
      this.name,
      this.description,
      this.date,
      this.priority,
      this.status});

  // Convert to map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'date': date?.toIso8601String(), // Handle nullable DateTime
      'priority': priority,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // From map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      priority: map['priority'],
      status: map['status'],
    );
  }
}
