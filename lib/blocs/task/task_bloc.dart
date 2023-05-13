import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:listify/models/g_task.dart';

import '../../models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoading()) {
    on<TaskLoadEvent>(_loadAllTask);
    on<TaskAddEvent>(_addTask);
    on<TaskMarkCompletedEvent>(_onMarkDone);
    on<TaskFavoriteEvent>(_onFavorite);
    on<TaskChangeCurrentEvent>(_onChangeCurrent);
    on<TaskSaveChangeTaskEvent>(_onSaveChange);
  }

  FutureOr<void> _loadAllTask(
      TaskLoadEvent event, Emitter<TaskState> emit) async {
    // print()
    Dio dio = Dio();

    final response = await dio.get('http://192.168.1.231:5000/gtask',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MDc4MywiZXhwIjoxNjg0MDM3MTgzfQ.eOpYEbzwP4JUkfG3D0bribfNmqj1e9CLg1FdkdwF64M"
        }));

    // print(response.data['data']);
    List<GTask> gTasks =
        (response.data['data'] as List).map((e) => GTask.fromJson(e)).toList();
    // print(gTasks[0].taskList[0].description);

    final List<Task> todayTasks = gTasks
        .where(
          (element) => element.name == 'Today',
        )
        .first
        .taskList;

    todayTasks.forEach(
      (e) => print(e.title),
    );

    print(todayTasks);

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      emit(currentState.copyWith(gTasks: gTasks, tasksDisplay: todayTasks));
    } else {
      emit(TaskLoaded(gTasks: gTasks, tasksDisplay: todayTasks, refresh: 0));
    }
  }

  FutureOr<void> _addTask(TaskAddEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      Dio dio = Dio();
      final String url = 'http://192.168.1.231:5000/task';

      final data = {
        "title": event.title,
        "description": event.description,
        "fromDate": DateTime.now().toUtc().toString(),
        "toDate": DateTime.now().toUtc().toString(),
      };

      print(DateTime.now().toUtc());

      final response = await dio.post(url,
          options: Options(headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MDc4MywiZXhwIjoxNjg0MDM3MTgzfQ.eOpYEbzwP4JUkfG3D0bribfNmqj1e9CLg1FdkdwF64M"
          }),
          data: data);

      print(response.data['data']['id']);

      dio.put(
          'http://192.168.1.231:5000/task/${response.data['data']['id']}/move',
          options: Options(headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MDc4MywiZXhwIjoxNjg0MDM3MTgzfQ.eOpYEbzwP4JUkfG3D0bribfNmqj1e9CLg1FdkdwF64M"
          }),
          data: {
            "groupTaskId": currentState.gTasks
                .where(
                  (element) => element.name == 'Today',
                )
                .first
                .id
          });
      add(TaskLoadEvent());
    }
  }

  FutureOr<void> _onMarkDone(
      TaskMarkCompletedEvent event, Emitter<TaskState> emit) async {
    Dio dio = Dio();
    await dio.put('http://192.168.1.231:5000/task/${event.task.id}/toggle-mark',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MDc4MywiZXhwIjoxNjg0MDM3MTgzfQ.eOpYEbzwP4JUkfG3D0bribfNmqj1e9CLg1FdkdwF64M"
        }));
    add(TaskLoadEvent());
  }

  FutureOr<void> _onFavorite(
      TaskFavoriteEvent event, Emitter<TaskState> emit) async {
    Dio dio = Dio();
    await dio.put('http://192.168.1.231:5000/task/${event.task.id}/toggle-favo',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MDc4MywiZXhwIjoxNjg0MDM3MTgzfQ.eOpYEbzwP4JUkfG3D0bribfNmqj1e9CLg1FdkdwF64M"
        }));
    add(TaskLoadEvent());
  }

  FutureOr<void> _onChangeCurrent(
      TaskChangeCurrentEvent event, Emitter<TaskState> emit) {
    print(event.task);

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      print('change');

      emit(currentState.copyWith(
          currentTask: event.task, refresh: currentState.refresh + 1));
    }
  }

  FutureOr<void> _onSaveChange(
      TaskSaveChangeTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      print(currentState.currentTask);

      // emit(currentState.copyWith(currentTask: event.task));
    }
  }
}
