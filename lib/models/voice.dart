// ignore_for_file: public_member_api_docs, sort_constructors_first

class Voice {
  final int id;
  final int taskId;
  final String name;
  final String file;

  Voice({required this.id, required this.taskId, required this.name,
      required this.file});



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskId'] = taskId;
    data['name'] = name;
    data['file'] = file;
    return data;
  }



  factory Voice.fromJson(Map<String, dynamic> map) {
    return Voice(
      id: map['id'] as int,
      taskId: map['taskId'] as int,
      name: map['name'] as String,
      file: map['file'] as String,
    );
  }


  Voice copyWith({
    int? id,
    int? taskId,
    String? name,
    String? file,
  }) {
    return Voice(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      name: name ?? this.name,
      file: file ?? this.file,
    );
  }
}
