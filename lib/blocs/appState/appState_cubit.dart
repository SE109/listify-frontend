
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_repo.dart';
import 'package:listify/models/group_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/task.dart';

part 'appState_state.dart';

class AppStateCubit extends Cubit<AppStateState> {
  AppStateCubit() : super(AppStateInitial());
  
  String  _theme = 'light';
  String get theme => _theme;
  GroupTask _currentGroupTask = GroupTask(id: -1 , name: 'Today', taskList: []);
  GroupTask get currentGroupTask => _currentGroupTask;

  Future<void> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeString = prefs.getString('theme') ?? 'light';
    changeTheme(themeString);

    changeCurrentGroupTask(await todayTask());
  }

  void changeTheme(value ) async {
    _theme = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme' , value);
    emit(ThemeChanged());
  }

  void changeCurrentGroupTask(value) {
    _currentGroupTask = value;
    emit(CurrentGroupTaskChanged());
  }

  void changeCurrentGroupTaskName(value) {
     _currentGroupTask.name = value;
    emit(CurrentGroupTaskChanged());
  }
  
  
  todayTask() async {
     List<GroupTask> list = await GroupTaskRepository().getAllGroupTasks();
     var fav = <Task>[];
      list.forEach((gt) {
      gt.taskList!.forEach((t) {
        final today = DateTime.now();
        final fromDate = DateTime.parse(t.fromDate!);
        final toDate = DateTime.parse(t.toDate!);
        if (today.isAfter(fromDate) && today.isBefore(toDate)) {
          fav.add(t);
        }
      });
    });
    return GroupTask(
      id: -1,
      name: 'Today',
      taskList: fav
    );
  }
}
