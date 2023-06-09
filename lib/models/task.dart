import 'package:equatable/equatable.dart';
import 'package:listify/models/voice.dart';

class MyTask extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isCompleted;
  final bool isFavorited;
  final List<SubTask> subTaskList;
  final List<Voice> voiceList;

  MyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isCompleted,
    required this.isFavorited,
    this.subTaskList = const [],
    this.voiceList = const [],
  });
  MyTask copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isCompleted,
    bool? isFavorited,
    List<SubTask>? subTaskList,
    List<Voice>? voiceList,
  }) =>
      MyTask(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        isCompleted: isCompleted ?? this.isCompleted,
        isFavorited: isFavorited ?? this.isFavorited,
        subTaskList: subTaskList ?? this.subTaskList,
        voiceList: voiceList ?? this.voiceList,
      );

  factory MyTask.fromJson(Map<String, dynamic> json) => MyTask(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        fromDate: DateTime.parse(json["fromDate"]),
        toDate: DateTime.parse(json["toDate"]),
        isCompleted: json["isCompleted"],
        isFavorited: json["isFavorited"],
        subTaskList: json["subTaskList"] != null
            ? List<SubTask>.from(
                json["subTaskList"].map((x) => SubTask.fromJson(x)))
            : [],
        voiceList: json["voiceList"] != null
            ? List<Voice>.from(json["voiceList"].map((x) => Voice.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "fromDate":
            "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "toDate":
            "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
        "isCompleted": isCompleted,
        "isFavorited": isFavorited,
        "subTaskList": List<SubTask>.from(subTaskList.map((x) => x.toJson())),
        "voiceList": List<Voice>.from(voiceList.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        fromDate,
        toDate,
        isCompleted,
        isFavorited,
        subTaskList,
        voiceList,
      ];
}

class SubTask {
  final int id;
  final int taskId;
  final String title;
  final bool isCompleted;

  SubTask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isCompleted,
  });

  SubTask copyWith({
    int? id,
    int? taskId,
    String? title,
    bool? isCompleted,
  }) =>
      SubTask(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        id: json["id"],
        taskId: json["taskId"],
        title: json["title"],
        isCompleted: json["isCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskId": taskId,
        "title": title,
        "isCompleted": isCompleted,
      };
}
