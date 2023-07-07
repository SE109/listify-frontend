import 'dart:collection';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/task/task_bloc.dart';
import '../../models/task.dart';
import 'list_item.dart';
import 'section_header.dart';

class ProgressSection extends StatefulWidget {
  const ProgressSection({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<MyTask> tasks;

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection> {
  final List<DateTime> dates = [];

  @override
  void initState() {
    // var groupByDate = groupBy(widget.tasks,
    //     (obj) => obj.fromDate.toUtc().toString().substring(0, 10));
    // print('-----------group ne');
    // widget.tasks.forEach(
    //   (element) => print(element.fromDate.toUtc()),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          print('-----------group ne');

          List<MyTask> taskDisplay = state.tasksDisplay
            ..sort((a, b) => b.toDate.compareTo(a.toDate));

          // print(taskDisplay);

          var groupByDate = groupBy(taskDisplay,
              (obj) => obj.toDate.toUtc().toString().substring(0, 10));
          List<String> dates = [];
          groupByDate =
              LinkedHashMap.fromEntries(groupByDate.entries.toList().reversed);
          groupByDate.forEach((date, list) {
            // Header
            dates.add(date);
            print('${date}:');

            // // Group
            // list.forEach((listItem) {
            //   // List item
            //   print('${listItem.fromDate}, ${listItem.fromDate}');
            // });
            // // day section divider
            // print('\naaa');
          });
          if (groupByDate.length == 0) {
            return const Column(children: [
              SizedBox(
                height: 250,
              ),
              Text('No tasks yet')
            ]);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NoDateTasks(tasks: tasks),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupByDate.length,
                itemBuilder: (context, index) => DateCategorizedTasks(
                  date: dates[index],
                  tasks: groupByDate[dates[index]]!,
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
    required this.date,
    required this.tasks,
  });

  final String date;
  final List<MyTask> tasks;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            title: date == DateTime.now().toUtc().toString().substring(0, 10)
                ? 'Today'
                : date),
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

  final List<MyTask> tasks;

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
              task: MyTask(
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
