// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:listify/models/task.dart';

class GroupTask {
  int? id;
  String? name;
  List<Task>? taskList;

  GroupTask({this.id, this.name, this.taskList});

  GroupTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['taskList'] != null) {
      taskList = <Task>[];
      json['taskList'].forEach((v) {
        taskList!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['taskList'] =
        taskList != null ? taskList!.map((v) => v.toJson()).toList() : null;
    return data;
  }

  GroupTask copyWith({
    int? id,
    String? name,
    List<Task>? taskList,
  }) {
    return GroupTask(
      id: id ?? this.id,
      name: name ?? this.name,
      taskList: taskList ?? this.taskList,
    );
  }
}
