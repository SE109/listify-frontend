// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'group_task_bloc.dart';

abstract class GroupTaskState extends Equatable {
  const GroupTaskState();
  
  @override
  List<Object> get props => [];
}

class GroupTaskInitial extends GroupTaskState {}
class GroupTaskLoading extends GroupTaskState {}
class GroupTaskLoaded extends GroupTaskState {
  List<GroupTask> groupTasks;
  GroupTaskLoaded({
    required this.groupTasks,
  });
  @override
  List<Object> get props => [groupTasks];
}
