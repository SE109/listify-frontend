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
  String? currentGTask;

  TaskLoaded(
      {required this.gTasks,
      this.taskSelected = 'Today',
      required this.tasksDisplay,
      required this.refresh,
      this.currentTask,
      this.currentGTask});

  TaskLoaded copyWith({
    final List<GTask>? gTasks,
    final List<Task>? tasksDisplay,
    final String? taskSelected,
    final Task? currentTask,
    final int? refresh,
    final String? currentGTask,
  }) {
    return TaskLoaded(
      gTasks: gTasks ?? this.gTasks,
      tasksDisplay: tasksDisplay ?? this.tasksDisplay,
      taskSelected: taskSelected ?? this.taskSelected,
      refresh: refresh ?? this.refresh,
      currentTask: currentTask ?? this.currentTask,
      currentGTask: currentGTask ?? this.currentGTask,
    );
  }

  @override
  List<Object> get props => [gTasks, taskSelected, tasksDisplay, refresh];
}
