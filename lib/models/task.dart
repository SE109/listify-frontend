
import 'package:listify/models/sub_task.dart';
import 'package:listify/models/voice.dart';

class Task {
  int? id;
  String? title;
  String? description;
  String? fromDate;
  String? toDate;
  bool? isCompleted;
  bool? isFavorited;
  List<SubTask?>? subTaskList;
  List<Voice?>? voiceList;

  Task(
      {this.id,
      this.title,
      this.description,
      this.fromDate,
      this.toDate,
      this.isCompleted,
      this.isFavorited,
      this.subTaskList,
      this.voiceList});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    isCompleted = json['isCompleted'];
    isFavorited = json['isFavorited'];
    if (json['subTaskList'] != null) {
      subTaskList = <SubTask>[];
      json['subTaskList'].forEach((v) {
        subTaskList!.add(SubTask.fromJson(v));
      });
    }
    if (json['voiceList'] != null) {
      voiceList = <Voice>[];
      json['voiceList'].forEach((v) {
        voiceList!.add(Voice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['isCompleted'] = isCompleted;
    data['isFavorited'] = isFavorited;
    data['subTaskList'] = subTaskList != null
        ? subTaskList!.map((v) => v?.toJson()).toList()
        : null;
    data['voiceList'] =
        voiceList != null ? voiceList!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}



