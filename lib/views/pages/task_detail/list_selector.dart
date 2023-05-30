import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/models/g_task.dart';
import 'package:listify/models/task.dart';
import 'package:provider/provider.dart';

import '../../../blocs/task/task_bloc.dart';

class ListSelector extends StatefulWidget {
  const ListSelector({
    Key? key,
    required this.task,
  }) : super(key: key);
  final MyTask task;

  @override
  State<ListSelector> createState() => _ListSelectorState();
}

class _ListSelectorState extends State<ListSelector> {
  @override
  Widget build(BuildContext context) {
    // final taskContentController = context.watch<TaskContentController>();
    // final taskListsController = context.watch<TaskListsController>();
    // final currentListId = taskContentController.listId;
    // String displayName = currentListId != null
    //     ? taskListsController.getList(currentListId).name
    //     : 'Not listed';

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const SizedBox();
        }
        if (state is TaskLoaded) {
          final gTask = state.gTasks
              .where(
                (element) => element.taskList
                    .any((element) => element.id == widget.task.id),
              )
              .first;
          final List<String> list = state.gTasks
              .map(
                (e) => e.name,
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 24,
              top: 4,
              bottom: 4,
            ),
            child: ElevatedButton(
              onPressed: () async {
                return showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) => ListSelectionBottomSheet(
                    list: list,
                    gTask: gTask,
                  ),
                );
              },
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.currentGTask!),
                        const Icon(Icons.arrow_drop_down_rounded),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ListSelectionBottomSheet extends StatelessWidget {
  const ListSelectionBottomSheet({
    Key? key,
    required this.list,
    required this.gTask,
    // required this.taskContentController,
  }) : super(key: key);

  final List<String> list;
  final GTask gTask;

  // final TaskContentController taskContentController;

  @override
  Widget build(BuildContext context) {
    // final taskListsController = context.watch<TaskListsController>();
    // final selection = taskListsController.tasklists;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Move task to',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    // bool isCurrentListId =
                    //     selection[index].id == taskContentController.listId;
                    return TextButton(
                      onPressed: state.currentGTask == list[index]
                          ? null
                          : () => BlocProvider.of<TaskBloc>(context).add(
                              TaskChangeGTaskEvent(gTaskName: list[index])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(list[index]),
                          state.currentGTask == list[index]
                              ? const Icon(Icons.check_rounded)
                              : Container()
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
