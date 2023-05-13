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
  final int refresh;
  Task? currentTask;

  TaskLoaded(
      {required this.gTasks,
      this.taskSelected = 'Today',
      required this.tasksDisplay,
      required this.refresh,
      this.currentTask});

  TaskLoaded copyWith({
    final List<GTask>? gTasks,
    final List<Task>? tasksDisplay,
    final String? taskSelected,
    final Task? currentTask,
    final int? refresh,
  }) {
    return TaskLoaded(
        gTasks: gTasks ?? this.gTasks,
        tasksDisplay: tasksDisplay ?? this.tasksDisplay,
        taskSelected: taskSelected ?? this.taskSelected,
        refresh: refresh ?? this.refresh,
        currentTask: currentTask ?? this.currentTask);
  }

  @override
  List<Object> get props => [gTasks, taskSelected, tasksDisplay, refresh];
}
