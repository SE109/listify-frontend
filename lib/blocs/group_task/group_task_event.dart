part of 'group_task_bloc.dart';

abstract class GroupTaskEvent extends Equatable {
  const GroupTaskEvent();

  @override
  List<Object> get props => [];
}
class AddGroupTask extends GroupTaskEvent {
  final String name;
  const AddGroupTask({
    required this.name,
  });


  @override
  List<Object> get props => [name];
}
class UpdateGroupTask extends GroupTaskEvent {
  final GroupTask groupTask;
  final String name;
  const UpdateGroupTask({
    required this.groupTask,
    required this.name,
  });

  @override
  List<Object> get props => [groupTask, name];
}

class DeleteGroupTask extends GroupTaskEvent {
  final GroupTask groupTask;
  const DeleteGroupTask({
    required this.groupTask,
  });

  @override
  List<Object> get props => [groupTask];
}
class GetAllGroupTasks extends GroupTaskEvent {
 
  @override
  List<Object> get props => [];
}
