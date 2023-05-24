class SubTask {
  int? id;
  int? taskId;
  String? title;
  bool? isCompleted;

  SubTask({this.id, this.taskId, this.title, this.isCompleted});

  SubTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['taskId'];
    title = json['title'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskId'] = taskId;
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
