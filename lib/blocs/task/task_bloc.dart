import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:listify/models/g_task.dart';
import 'package:logger/logger.dart';

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
    on<TaskChangeGTaskEvent>(_onChangeCurrentGTask);
    on<TaskRefreshEvent>(_onRefresh);
  }

  FutureOr<void> _loadAllTask(
      TaskLoadEvent event, Emitter<TaskState> emit) async {
    // print()
    Dio dio = Dio();

    final response = await dio.get('http://10.0.2.2:5000/gtask',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
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

      emit(currentState.copyWith(
          gTasks: gTasks, tasksDisplay: todayTasks, currentGTask: 'Today'));
    } else {
      emit(TaskLoaded(
          gTasks: gTasks,
          tasksDisplay: todayTasks,
          refresh: 0,
          currentGTask: 'Today'));
    }
  }

  FutureOr<void> _addTask(TaskAddEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      Dio dio = Dio();
      final String url = 'http://10.0.2.2:5000/task';

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
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
          }),
          data: data);

      print(response.data['data']['id']);

      dio.put('http://10.0.2.2:5000/task/${response.data['data']['id']}/move',
          options: Options(headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
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
    await dio.put('http://10.0.2.2:5000/task/${event.task.id}/toggle-mark',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
        }));
    add(TaskLoadEvent());
  }

  FutureOr<void> _onFavorite(
      TaskFavoriteEvent event, Emitter<TaskState> emit) async {
    Dio dio = Dio();
    await dio.put('http://10.0.2.2:5000/task/${event.task.id}/toggle-favo',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
        }));
    add(TaskLoadEvent());
  }

  FutureOr<void> _onChangeCurrent(
      TaskChangeCurrentEvent event, Emitter<TaskState> emit) {
    print(event.task);

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      print('change');

      final gTask = currentState.gTasks.firstWhere(
        (element) =>
            element.taskList.any((element) => element.id == event.task.id),
      );

      emit(currentState.copyWith(
          currentTask: event.task,
          refresh: currentState.refresh + 1,
          currentGTask: gTask.name));
    }
  }

  FutureOr<void> _onSaveChange(
      TaskSaveChangeTaskEvent event, Emitter<TaskState> emit) async {
    Dio dio = Dio();
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      currentState.currentTask!.subTaskList.forEach(
        (element) => Logger().v(element.title),
      );
      final gTask = currentState.gTasks.firstWhere(
        (element) => element.taskList
            .any((element) => element.id == currentState.currentTask!.id),
      );
      if (gTask.name != currentState.currentGTask) {
        // http://localhost:5000/task/104/move
        await dio.put(
            'http://10.0.2.2:5000/task/${currentState.currentTask!.id}/move',
            options: Options(
              headers: {
                "Authorization":
                    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
              },
            ),
            data: {
              "groupTaskId": currentState.gTasks
                  .firstWhere(
                      (element) => element.name == currentState.currentGTask)
                  .id
            });
      }

      await dio.put('http://10.0.2.2:5000/task/${currentState.currentTask!.id}',
          options: Options(
            headers: {
              "Authorization":
                  "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4Mzk1MTcyMiwiZXhwIjoxNjg0MDM4MTIyfQ._3tKY9x9DJqNkg67IlIarZ637djopqqKfwC_N6bsPK0"
            },
          ),
          data: {
            "title": event.title,
            "description": event.detail,
            "fromDate": currentState.currentTask!.fromDate.toUtc().toString(),
            "toDate": currentState.currentTask!.toDate.toUtc().toString(),
          });

      add(TaskLoadEvent());

      // emit(currentState.copyWith(currentTask: event.task));
    }
  }

  FutureOr<void> _onChangeCurrentGTask(
      TaskChangeGTaskEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      emit(currentState.copyWith(
          currentGTask: event.gTaskName, refresh: currentState.refresh + 1));
    }
  }

  FutureOr<void> _onRefresh(TaskRefreshEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      emit(currentState.copyWith(refresh: currentState.refresh + 1));
    }
  }
}
