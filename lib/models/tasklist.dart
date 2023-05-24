import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  final int id;
  final String name;

  const TaskList({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  TaskList copyWith({
    int? id,
    String? name,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory TaskList.fromMap(Map<String, dynamic> json) => TaskList(
        id: json['id'],
        name: json['name'],
      );
}
