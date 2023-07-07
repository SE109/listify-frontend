import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    on<TaskUpdateGTaskEvent>(_onUpdateGTask);
    on<TaskCompleteSubtaskEvent>(_onCompleteSubTask);
    on<TaskLoadAllFavoriteEvent>(_onLoadAllFavorite);
    on<TaskReloadTaskEvent>(_reLoadAllTask);
    on<TaskDeleteAllCompletedTaskEvent>(_onDeleteTaskCompleted);
    on<TaskDeleteGroupTask>(_onDeleteTaskGroup);
  }

  FutureOr<void> _loadAllTask(
      TaskLoadEvent event, Emitter<TaskState> emit) async {
    // print()
    Dio dio = UserRepository.dio;

    final token = await const FlutterSecureStorage().read(key: 'accessToken');

    final response = await dio.get(
      '/gtask',
    );

    // print(response.data['data']);
    List<GTask> gTasks =
        (response.data['data'] as List).map((e) => GTask.fromJson(e)).toList();

    print('ngyu');
    // print(gTasks[0].taskList[0].description);

    final List<MyTask> todayTasks = gTasks
        .firstWhere(
          (element) => element.name == 'Today',
        )
        .taskList;

    // todayTasks.forEach(
    //   (e) => print(e.title),
    // );

    print(todayTasks);

    if (state is TaskLoaded) {
      print('load again');
      final currentState = state as TaskLoaded;

      if (currentState.gTaskSelected == 'Favorite') {
        final response = await dio.get(
          '/task/fav',
        );
        emit(
          currentState.copyWith(
              gTasks: gTasks,
              tasksDisplay: (response.data['data'] as List)
                  .map((e) => MyTask.fromJson(e))
                  .toList(),
              currentGTask: currentState.currentGTask,
              gTaskSelected: currentState.gTaskSelected),
        );
      } else if (currentState.gTaskSelected != 'Today') {
        final response = await dio.get(
          '/gtask',
        );

        List<GTask> gTasks = (response.data['data'] as List)
            .map((e) => GTask.fromJson(e))
            .toList();

        final resultList = gTasks
            .firstWhere((element) => element.name == currentState.gTaskSelected)
            .taskList;
        emit(
          currentState.copyWith(
              gTasks: gTasks,
              tasksDisplay: resultList,
              currentGTask: currentState.currentGTask,
              gTaskSelected: currentState.gTaskSelected),
        );
      } else {
        emit(
          currentState.copyWith(
              gTasks: gTasks,
              tasksDisplay: todayTasks,
              currentGTask: currentState.currentGTask,
              gTaskSelected: currentState.gTaskSelected),
        );
      }
    } else {
      emit(TaskLoaded(
          gTasks: gTasks,
          tasksDisplay: todayTasks,
          refresh: 0,
          currentGTask: 'Today',
          taskFavorite: const []));
    }
  }

  FutureOr<void> _reLoadAllTask(
      TaskReloadTaskEvent event, Emitter<TaskState> emit) async {
    // print()
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      Dio dio = UserRepository.dio;

      // final token = await FlutterSecureStorage().read(key: 'accessToken');

      final response = await dio.get(
        '/gtask',
      );

      // print(response.data['data']);
      List<GTask> gTasks = (response.data['data'] as List)
          .map((e) => GTask.fromJson(e))
          .toList();

      // await Future.delayed(Duration(milliseconds: 100));

      print('ngyu');
      // print(gTasks[0].taskList[0].description);

      final List<MyTask> todayTasks = gTasks
          .firstWhere(
            (element) => element.name == currentState.gTaskSelected,
          )
          .taskList;

      emit(currentState.copyWith(gTasks: gTasks, tasksDisplay: todayTasks));
    }

    // print(todayTasks);

    // if (state is TaskLoaded) {

    //   emit(currentState.copyWith(
    //       gTasks: gTasks, tasksDisplay: todayTasks));
    // } else {
    //   emit(TaskLoaded(
    //       gTasks: gTasks,
    //       tasksDisplay: todayTasks,
    //       refresh: 0,
    //       currentGTask: 'Today',
    //       taskFavorite: []));
    // }
  }

  FutureOr<void> _addTask(TaskAddEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      Dio dio = UserRepository.dio;

      const String url = '/task';

      final data = {
        "title": event.title,
        "description": event.description,
        "fromDate": (event.fromDate.add(Duration(seconds: 1)))
            .toUtc()
            .toLocal()
            .toString(),
        "toDate": (event.toDate.add(Duration(seconds: 1)))
            .toUtc()
            .toLocal()
            .toString(),
      };
      print('-------date utc');
      print(DateTime.now());

      final token = await const FlutterSecureStorage().read(key: 'accessToken');

      final response = await dio.post(url, data: data);

      print(response.data['data']['id']);

      await dio.put('/task/${response.data['data']['id']}/move', data: {
        "groupTaskId": currentState.gTasks
            .where(
              (element) => element.name == 'Today',
            )
            .first
            .id
      });
      add(TaskReloadTaskEvent());
    }
  }

  FutureOr<void> _onMarkDone(
      TaskMarkCompletedEvent event, Emitter<TaskState> emit) async {
    Dio dio = UserRepository.dio;
    await dio.put(
      '/task/${event.task.id}/toggle-mark',
    );
    add(TaskReloadTaskEvent());
  }

  FutureOr<void> _onFavorite(
      TaskFavoriteEvent event, Emitter<TaskState> emit) async {
    Dio dio = UserRepository.dio;
    await dio.put(
      '/task/${event.task.id}/toggle-favo',
    );
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

      for (var element in currentState.currentTask!.subTaskList) {
        Logger().v(element.title);
      }
      final gTask = currentState.gTasks.firstWhere(
        (element) => element.taskList
            .any((element) => element.id == currentState.currentTask!.id),
      );
      if (gTask.name != currentState.currentGTask) {
        // http://localhost:5000/task/104/move
        await dio.put('/task/${currentState.currentTask!.id}/move', data: {
          "groupTaskId": currentState.gTasks
              .firstWhere(
                  (element) => element.name == currentState.currentGTask)
              .id
        });
      }

      //http://localhost:5000/task/subtask/1

      await dio.delete(
        '/task/subtask/${currentState.currentTask!.id}',
      );

      for (var e in currentState.currentTask!.subTaskList) {
        await dio.post('/subtask',
            data: {"taskId": currentState.currentTask!.id, "title": e.title});
      }

      print('------save change date time');
      print(currentState.currentTask!.fromDate.toUtc().toLocal());

      await dio.put('/task/${currentState.currentTask!.id}', data: {
        "title": event.title,
        "description": event.detail.trim(),
        "fromDate":
            currentState.currentTask!.fromDate.toUtc().toLocal().toString(),
        "toDate": currentState.currentTask!.toDate.toUtc().toLocal().toString(),
      });

      add(TaskReloadTaskEvent());

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
        '/task/${currentState.currentTask!.id}',
      );

      emit(currentState.copyWith(
          currentTask: null, refresh: currentState.refresh + 1));
      add(TaskLoadEvent());
      // if (currentState.gTaskSelected == 'Favorite') {
      //   add(TaskLoadAllFavoriteEvent());
      // } else {

      // }
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

    await dio.post('/gtask', data: {"name": event.name});

    add(TaskReloadTaskEvent());
  }

  FutureOr<void> _onCompleteSubTask(
      TaskCompleteSubtaskEvent event, Emitter<TaskState> emit) async {
    final Dio dio = UserRepository.dio;
    await dio.put(
      '/subtask/${event.id}/toggle-mark',
    );
    add(TaskLoadEvent());
  }

  FutureOr<void> _onLoadAllFavorite(
      TaskLoadAllFavoriteEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      Dio dio = UserRepository.dio;
      // add(TaskReloadTaskEvent());
      final response = await dio.get(
        '/task/fav',
      );
      emit(currentState.copyWith(
          tasksDisplay: (response.data['data'] as List)
              .map((e) => MyTask.fromJson(e))
              .toList()));
    }
  }

  FutureOr<void> _onUpdateGTask(
      TaskUpdateGTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      final Dio dio = UserRepository.dio;

      await dio.put('/gtask/${event.gTask.id}', data: {"name": event.name});

      //load all gtasks
      final response = await dio.get(
        '/gtask',
      );

      // print(response.data['data']);
      List<GTask> gTasks = (response.data['data'] as List)
          .map((e) => GTask.fromJson(e))
          .toList();
      emit(currentState.copyWith(gTasks: gTasks, gTaskSelected: event.name));
    }
  }

  FutureOr<void> _onDeleteTaskCompleted(
      TaskDeleteAllCompletedTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      int id = 0;
      if (event.gTask.name == 'Today') {
        var gTask = currentState.gTasks
            .firstWhere((element) => element.name == 'Today');
        id = gTask.id;
        for (var item in gTask.taskList) {
          if (item.isCompleted) {
            await deleteTask(item.id);
          }
        }
      } else if (event.gTask.name == 'Favorite') {
        id = -1;
      } else {
        var gTask = currentState.gTasks
            .firstWhere((element) => element.id == event.gTask.id);
        id = gTask.id;
        for (var item in gTask.taskList) {
          if (item.isCompleted) {
            await deleteTask(item.id);
          }
        }
      }

      Dio dio = UserRepository.dio;
      final response = await dio.get(
        '/gtask',
      );
      List<GTask> gTasks = (response.data['data'] as List)
          .map((e) => GTask.fromJson(e))
          .toList();

      emit(currentState.copyWith(gTasks: gTasks));
      add(TaskChangeGTaskListEvent(gTaskId: id));
    }
  }

  Future<void> deleteTask(int id) async {
    final Dio dio = UserRepository.dio;
    await dio.delete('/task/$id');
  }

  FutureOr<void> _onDeleteTaskGroup(
      TaskDeleteGroupTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      var currentState = state as TaskLoaded;
      Dio dio = UserRepository.dio;
      final response = await dio.delete(
        '/gtask/${event.gTask.id}',
      );

      emit(currentState.copyWith(gTaskSelected: 'Today'));
      add(TaskLoadEvent());
    }
  }
}
