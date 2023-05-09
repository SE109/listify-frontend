class Voice {
  int? id;
  int? taskId;
  String? name;
  String? file;

  Voice({this.id, this.taskId, this.name, this.file});

  Voice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['taskId'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskId'] = taskId;
    data['name'] = name;
    data['file'] = file;
    return data;
  }
}
