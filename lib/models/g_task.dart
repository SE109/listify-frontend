import 'package:listify/models/task.dart';

class GTask {
    final int id;
    final String name;
    final List<MyTask> taskList;

    GTask({
        required this.id,
        required this.name,
        required this.taskList,
    });

    GTask copyWith({
        int? id,
        String? name,
        List<MyTask>? taskList,
    }) => 
        GTask(
            id: id ?? this.id,
            name: name ?? this.name,
            taskList: taskList ?? this.taskList,
        );

    factory GTask.fromJson(Map<String, dynamic> json) => GTask(
        id: json["id"],
        name: json["name"],
        taskList: List<MyTask>.from(json["taskList"].map((x) => MyTask.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "taskList": List<dynamic>.from(taskList.map((x) => x.toJson())),
    };
}

// class TaskList {
//     final int id;
//     final String title;
//     final String description;
//     final DateTime fromDate;
//     final DateTime toDate;
//     final bool isCompleted;
//     final bool isFavorited;
//     final List<dynamic> subTaskList;
//     final List<dynamic> voiceList;

//     TaskList({
//         required this.id,
//         required this.title,
//         required this.description,
//         required this.fromDate,
//         required this.toDate,
//         required this.isCompleted,
//         required this.isFavorited,
//         required this.subTaskList,
//         required this.voiceList,
//     });

//     TaskList copyWith({
//         int? id,
//         String? title,
//         String? description,
//         DateTime? fromDate,
//         DateTime? toDate,
//         bool? isCompleted,
//         bool? isFavorited,
//         List<dynamic>? subTaskList,
//         List<dynamic>? voiceList,
//     }) => 
//         TaskList(
//             id: id ?? this.id,
//             title: title ?? this.title,
//             description: description ?? this.description,
//             fromDate: fromDate ?? this.fromDate,
//             toDate: toDate ?? this.toDate,
//             isCompleted: isCompleted ?? this.isCompleted,
//             isFavorited: isFavorited ?? this.isFavorited,
//             subTaskList: subTaskList ?? this.subTaskList,
//             voiceList: voiceList ?? this.voiceList,
//         );

//     factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
//         id: json["id"],
//         title: json["title"],
//         description: json["description"],
//         fromDate: DateTime.parse(json["fromDate"]),
//         toDate: DateTime.parse(json["toDate"]),
//         isCompleted: json["isCompleted"],
//         isFavorited: json["isFavorited"],
//         subTaskList: List<dynamic>.from(json["subTaskList"].map((x) => x)),
//         voiceList: List<dynamic>.from(json["voiceList"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "fromDate": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
//         "toDate": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
//         "isCompleted": isCompleted,
//         "isFavorited": isFavorited,
//         "subTaskList": List<dynamic>.from(subTaskList.map((x) => x)),
//         "voiceList": List<dynamic>.from(voiceList.map((x) => x)),
//     };
// }
