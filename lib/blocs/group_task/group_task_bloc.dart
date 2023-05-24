import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listify/models/group_task.dart';

import 'group_task_repo.dart';

part 'group_task_event.dart';
part 'group_task_state.dart';

class GroupTaskBloc extends Bloc<GroupTaskEvent, GroupTaskState> {

  final repo = GroupTaskRepository();
  
  GroupTaskBloc() : super(GroupTaskInitial()) {
    on<AddGroupTask>(_onAddGroupTask);
    on<UpdateGroupTask>(_onUpdateGroupTask);
    on<DeleteGroupTask>(_onDeleteGroupTask);
    on<GetAllGroupTasks>(_onGetAllGroupTasks);
  }

  FutureOr<void> _onAddGroupTask(AddGroupTask event, Emitter<GroupTaskState> emit)  async {
     var name = event.name;
    await Future.delayed(const Duration(seconds: 1));
    try {
      await repo.createGroupTask(name);
      final list = await repo.getAllGroupTasks();
      emit(GroupTaskLoaded(groupTasks: list));
    } catch (e) {
      throw Exception(e.toString());
    }
  
  }
  FutureOr<void> _onDeleteGroupTask(DeleteGroupTask event, Emitter<GroupTaskState> emit) async {
    var id = event.groupTask.id;
    await Future.delayed(const Duration(seconds: 1));
    try {
      await repo.deleteGroupTask(id);
      final list = await repo.getAllGroupTasks();
      emit(GroupTaskLoaded(groupTasks: list));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  FutureOr<void> _onUpdateGroupTask(UpdateGroupTask event, Emitter<GroupTaskState> emit) async {
    var id = event.groupTask.id;
    var name = event.name;
    await Future.delayed(const Duration(seconds: 1));
    try {
      await repo.updateGroupTask(id,name);
      final list = await repo.getAllGroupTasks();
      emit(GroupTaskLoaded(groupTasks: list));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  FutureOr<void> _onGetAllGroupTasks(GetAllGroupTasks event, Emitter<GroupTaskState> emit) async {
    emit(GroupTaskLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      List<GroupTask> list = await repo.getAllGroupTasks();
      emit(GroupTaskLoaded(groupTasks: list));
    } catch (e) {
      throw Exception(e.toString());
    }
    
  }
}
