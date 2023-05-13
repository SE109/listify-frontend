import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/task/task_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../pages/task_detail/task_detail.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const ValueKey('string'),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 12),
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.cancel_outlined,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      child: task.description == null || task.description.isEmpty
          ? OneLineListTile(task: task)
          : TwoLineListTile(task: task),
    );
  }
}

class TwoLineListTile extends StatelessWidget {
  const TwoLineListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    // final taskListsController = context.watch<TaskListsController>();
    // final tasksController = context.watch<TasksController>();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) {
              BlocProvider.of<TaskBloc>(context)
                  .add(TaskChangeCurrentEvent(task: task));
            },
            child:
                // Container()
                TaskContentScreen(
              task: task, 
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: task.isCompleted
              ? const Icon(Icons.check_box_rounded)
              : const Icon(Icons.check_box_outline_blank_rounded),
          onPressed: () {
            BlocProvider.of<TaskBloc>(context)
                .add(TaskMarkCompletedEvent(task: task));
          },
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
        ),
        subtitle: Text(
          task.description,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                decorationThickness: 1.5,
              ),
        ),
        trailing: IconButton(
          icon: task.isFavorited
              ? const Icon(Icons.star_rounded)
              : const Icon(Icons.star_border_rounded),
          onPressed: () {
            BlocProvider.of<TaskBloc>(context)
                .add(TaskFavoriteEvent(task: task));
          },
        ),
      ),
    );
  }
}

class OneLineListTile extends StatelessWidget {
  const OneLineListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    // final taskListsController = context.watch<TaskListsController>();
    // final tasksController = context.watch<TasksController>();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) {
              BlocProvider.of<TaskBloc>(context)
                  .add(TaskChangeCurrentEvent(task: task));
            },
            child:
                // Container()
                TaskContentScreen(
              task: task,
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: task.isCompleted
              ? const Icon(Icons.check_box_rounded)
              : const Icon(Icons.check_box_outline_blank_rounded),
          onPressed: () {
            BlocProvider.of<TaskBloc>(context)
                .add(TaskMarkCompletedEvent(task: task));
          },
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
        ),
        trailing: IconButton(
          icon: task.isFavorited
              ? const Icon(Icons.star_rounded)
              : const Icon(Icons.star_border_rounded),
          onPressed: () {
            BlocProvider.of<TaskBloc>(context)
                .add(TaskFavoriteEvent(task: task));
          },
        ),
      ),
    );
  }
}
