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
  final List<Task> taskFavorite;
  final String gTaskSelected;
  final int refresh;
  Task? currentTask;
  String? currentGTask;

  TaskLoaded(
      {required this.gTasks,
      this.gTaskSelected = 'Today',
      required this.tasksDisplay,
      required this.refresh,
      required this.taskFavorite,
      this.currentTask,
      this.currentGTask});

  TaskLoaded copyWith({
    final List<GTask>? gTasks,
    final List<Task>? tasksDisplay,
    final String? gTaskSelected,
    final Task? currentTask,
    final int? refresh,
    final String? currentGTask,
    final List<Task>? taskFavorite
  }) {
    return TaskLoaded(
      gTasks: gTasks ?? this.gTasks,
      tasksDisplay: tasksDisplay ?? this.tasksDisplay,
      gTaskSelected: gTaskSelected ?? this.gTaskSelected,
      refresh: refresh ?? this.refresh,
      taskFavorite: taskFavorite ?? this.taskFavorite,
      currentTask: currentTask ?? this.currentTask,
      currentGTask: currentGTask ?? this.currentGTask,
    );
  }

  @override
  List<Object> get props => [gTasks, gTaskSelected, tasksDisplay, refresh];
}