part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskLoadEvent extends TaskEvent {}

class TaskAddEvent extends TaskEvent {
  final String title;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;

  const TaskAddEvent(
      {required this.title,
      required this.description,
      required this.fromDate,
      required this.toDate});
}

class TaskMarkCompletedEvent extends TaskEvent {
  final Task task;

  const TaskMarkCompletedEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskFavoriteEvent extends TaskEvent {
  final Task task;

  const TaskFavoriteEvent({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskChangeCurrentEvent extends TaskEvent {
  final Task task;

  const TaskChangeCurrentEvent({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskSaveChangeTaskEvent extends TaskEvent {}
