import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:listify/models/g_task.dart';
import 'package:listify/repositories/user_repository.dart';
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
    on<TaskDeleteEvent>(_onDeleteTask);
    on<TaskChangeGTaskListEvent>(_onChangeGTaskList);
    on<TaskAddGTaskEvent>(_onAddGTask);
    on<TaskCompleteSubtaskEvent>(_onCompleteSubTask);
    on<TaskLoadAllFavoriteEvent>(_onLoadAllFavorite);
  }

  FutureOr<void> _loadAllTask(
      TaskLoadEvent event, Emitter<TaskState> emit) async {
    // print()
    Dio dio = UserRepository.dio;

    final token = await FlutterSecureStorage().read(key: 'accessToken');

    final response = await dio.get(
      '/gtask',
    );

    // print(response.data['data']);
    List<GTask> gTasks =
        (response.data['data'] as List).map((e) => GTask.fromJson(e)).toList();

    print('ngyu');
    // print(gTasks[0].taskList[0].description);

    final List<Task> todayTasks = gTasks
        .firstWhere(
          (element) => element.name == 'Today',
        )
        .taskList;

    // todayTasks.forEach(
    //   (e) => print(e.title),
    // );

    print(todayTasks);

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      emit(currentState.copyWith(
          gTasks: gTasks, tasksDisplay:todayTasks, currentGTask: 'Today'));
    } else {
      emit(TaskLoaded(
          gTasks: gTasks,
          tasksDisplay: todayTasks,
          refresh: 0,
          currentGTask: 'Today',
          taskFavorite: []));
    }
  }

  FutureOr<void> _addTask(TaskAddEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      Dio dio = UserRepository.dio;

      final String url = '/task';

      final data = {
        "title": event.title,
        "description": event.description,
        "fromDate": DateTime.now().toUtc().toString(),
        "toDate": event.toDate.toUtc().toString(),
      };

      print(DateTime.now().toUtc());

      final token = await FlutterSecureStorage().read(key: 'accessToken');

      final response = await dio.post(url, data: data);

      print(response.data['data']['id']);

      dio.put('/task/${response.data['data']['id']}/move', data: {
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
    Dio dio = UserRepository.dio;
    await dio.put('http://192.168.1.231:5000/task/${event.task.id}/toggle-mark',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
        }));
    add(TaskLoadEvent());
  }

  FutureOr<void> _onFavorite(
      TaskFavoriteEvent event, Emitter<TaskState> emit) async {
    Dio dio = UserRepository.dio;
    await dio.put('http://192.168.1.231:5000/task/${event.task.id}/toggle-favo',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
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
    Dio dio = UserRepository.dio;
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
            'http://192.168.1.231:5000/task/${currentState.currentTask!.id}/move',
            options: Options(
              headers: {
                "Authorization":
                    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
              },
            ),
            data: {
              "groupTaskId": currentState.gTasks
                  .firstWhere(
                      (element) => element.name == currentState.currentGTask)
                  .id
            });
      }

      //http://localhost:5000/task/subtask/1

      await dio.delete(
        'http://192.168.1.231:5000/task/subtask/${currentState.currentTask!.id}',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
          },
        ),
      );

      for (var e in currentState.currentTask!.subTaskList) {
        await dio.post('http://192.168.1.231:5000/subtask',
            options: Options(
              headers: {
                "Authorization":
                    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
              },
            ),
            data: {"taskId": currentState.currentTask!.id, "title": e.title});
      }

      await dio
          .put('http://192.168.1.231:5000/task/${currentState.currentTask!.id}',
              options: Options(
                headers: {
                  "Authorization":
                      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
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

  FutureOr<void> _onDeleteTask(
      TaskDeleteEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      Dio dio = UserRepository.dio;

      print(currentState.currentTask!.id);

      await dio.delete(
        'http://192.168.1.231:5000/task/${currentState.currentTask!.id}',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
          },
        ),
      );

      emit(currentState.copyWith(
          currentTask: null, refresh: currentState.refresh + 1));

      add(TaskLoadEvent());
    }
  }

  FutureOr<void> _onChangeGTaskList(
      TaskChangeGTaskListEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      if (event.gTaskId == -1) {
        add(TaskLoadAllFavoriteEvent());
        emit(currentState.copyWith(gTaskSelected: 'Favorite'));
      } else {
        final resultList = currentState.gTasks
            .firstWhere((element) => element.id == event.gTaskId)
            .taskList;

        final name = currentState.gTasks
            .firstWhere((element) => element.id == event.gTaskId)
            .name;

        emit(currentState.copyWith(
            tasksDisplay: resultList, gTaskSelected: name));
      }
    }
  }

  FutureOr<void> _onAddGTask(
      TaskAddGTaskEvent event, Emitter<TaskState> emit) async {
    final Dio dio = UserRepository.dio;

    await dio.post('http://192.168.1.231:5000/gtask',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
          },
        ),
        data: {"name": event.name});

    add(TaskLoadEvent());
  }

  FutureOr<void> _onCompleteSubTask(
      TaskCompleteSubtaskEvent event, Emitter<TaskState> emit) async {
    final Dio dio = UserRepository.dio;
    await dio.put(
      'http://192.168.1.231:5000/subtask/${event.id}/toggle-mark',
      options: Options(
        headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
        },
      ),
    );
    add(TaskLoadEvent());
  }

  FutureOr<void> _onLoadAllFavorite(
      TaskLoadAllFavoriteEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      Dio dio = UserRepository.dio;

      final response = await dio.get('http://192.168.1.231:5000/task/fav',
          options: Options(headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMTM2NkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDY3Njk1NiwiZXhwIjoxNjg0NzYzMzU2fQ.UmTeMyAa68cGc8WPbuwUfhXI8pH_aVwDZ15Rzrz8IRI"
          }));
      emit(currentState.copyWith(
          tasksDisplay: (response.data['data'] as List)
              .map((e) => Task.fromJson(e))
              .toList()));
    }
  }
}
