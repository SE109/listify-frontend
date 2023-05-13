import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/task/task_bloc.dart';
import '../../models/task.dart';
import 'list_item.dart';
import 'section_header.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = [];

    // if (tasks.isEmpty) return Container();

    // for (final task in tasks) {
    //   if (task.time != null && !dates.contains(task.time!)) {
    //     dates.add(task.time!);
    //   }
    // }

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const SizedBox();
        } else if (state is TaskLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NoDateTasks(tasks: tasks),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) => DateCategorizedTasks(
                  tasks: state.tasksDisplay,
                  // date: dates[index],
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class DateCategorizedTasks extends StatelessWidget {
  const DateCategorizedTasks({
    super.key,
    // required this.date,
    required this.tasks,
  });

  // final DateTime date;
  final List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    // final list = tasks
    //     .where((element) =>
    //         !element.completed &&
    //         element.time != null &&
    //         element.time!.compareTo(date) == 0)
    //     .toList();

    // if (list.isEmpty) return Container();

    // String label =
    //     getLabelFromDuration(calculateDifference(date, DateTime.now()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SectionHeader(title: label.isEmpty ? formatDate(date) : label),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) => ListItem(task: tasks[index]),
        ),
      ],
    );
  }
}

class NoDateTasks extends StatelessWidget {
  const NoDateTasks({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    // final list = tasks
    //     .where((element) => !element.completed && element.time == null)
    //     .toList();

    // if (list.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'No date'),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) => ListItem(
              task: Task(
                  id: 1,
                  title: 'title',
                  description: 'description',
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  isCompleted: false,
                  isFavorited: false)),
        )
      ],
    );
  }
}
