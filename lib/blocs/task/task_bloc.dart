import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:listify/models/g_task.dart';

import '../../models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoading()) {
    on<TaskLoadEvent>(_loadAllTask);
  }

  FutureOr<void> _loadAllTask(
      TaskLoadEvent event, Emitter<TaskState> emit) async {
    // print()
    Dio dio = Dio();

    final response = await dio.get('http://10.0.2.2:5000/gtask',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4MzU5ODI4MSwiZXhwIjoxNjgzNjg0NjgxfQ.wJsbuxQMc5LkZ2fxCBMwFZfzHvwcaOKZ3gqmv4qOSoE"
        }));

    print(response.data['data']);
    List<GTask> gTasks =
        (response.data['data'] as List).map((e) => GTask.fromJson(e)).toList();
    print(gTasks[0].taskList[0].description);

    emit(TaskLoaded(gTasks: gTasks, tasksDisplay: gTasks[0].taskList));
  }
}
