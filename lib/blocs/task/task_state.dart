part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<GTask> gTasks;
  final List<MyTask> tasksDisplay;
  final List<MyTask> taskFavorite;
  final String gTaskSelected;
  final int refresh;
  MyTask? currentTask;
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
    final List<MyTask>? tasksDisplay,
    final String? gTaskSelected,
    final MyTask? currentTask,
    final int? refresh,
    final String? currentGTask,
    final List<MyTask>? taskFavorite
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
