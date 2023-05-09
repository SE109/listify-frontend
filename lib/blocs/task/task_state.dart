part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<GTask> gTasks;
  final List<Task> tasksDisplay;
  final String taskSelected;

  const TaskLoaded(
      {required this.gTasks, this.taskSelected = 'Today', required this.tasksDisplay});

  @override
  List<Object> get props => [gTasks, taskSelected, tasksDisplay];
}
