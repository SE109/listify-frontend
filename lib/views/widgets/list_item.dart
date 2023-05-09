import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';

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
            create: (_) {},
            child:Container() 
            // const TaskContentScreen(),
          ),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: false
              ? const Icon(Icons.check_box_rounded)
              : const Icon(Icons.check_box_outline_blank_rounded),
          onPressed: () {},
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration: false ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
        ),
        subtitle: Text(
          task.description,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                decoration: false ? TextDecoration.lineThrough : null,
                decorationThickness: 1.5,
              ),
        ),
        trailing: IconButton(
          icon: false
              ? const Icon(Icons.star_rounded)
              : const Icon(Icons.star_border_rounded),
          onPressed: () {},
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
      onTap: () {} 
      // => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ChangeNotifierProvider(
      //       create: (_) => TaskContentController(
      //         taskListsController,
      //         tasksController,
      //         task.id,
      //       )..loadData(),
      //       child: const TaskContentScreen(),
      //     ),
      //   ),
      // )
      ,
      child: ListTile(
        leading: IconButton(
          icon: false
              ? const Icon(Icons.check_box_rounded)
              : const Icon(Icons.check_box_outline_blank_rounded),
          onPressed: () {},
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration: false  ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
        ),
        trailing: IconButton(
          icon: false
              ? const Icon(Icons.star_rounded)
              : const Icon(Icons.star_border_rounded),
          onPressed: () {},
        ),
      ),
    );
  }
}
