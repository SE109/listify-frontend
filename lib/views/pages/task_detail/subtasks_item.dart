import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../blocs/task/task_bloc.dart';
import '../../../models/task.dart';
import '../../widgets/section_header.dart';

class SubtasksItem extends StatelessWidget {
  const SubtasksItem({
    Key? key,
    required this.task,
  }) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Subtasks'),
              state.currentTask!.subTaskList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.currentTask!.subTaskList.length,
                        itemBuilder: (_, index) => SubTaskItem(
                          item: state.currentTask!.subTaskList[index],
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    state.currentTask!.subTaskList.add(SubTask(
                        id: state.currentTask!.subTaskList.length,
                        taskId: state.currentTask!.id,
                        title: '',
                        isCompleted: false));
                    BlocProvider.of<TaskBloc>(context).add(TaskRefreshEvent());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_rounded),
                      SizedBox(width: 8),
                      Text('Add subtask'),
                    ],
                  ),
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

class SubTaskItem extends StatefulWidget {
  const SubTaskItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SubTask item;

  @override
  State<SubTaskItem> createState() => _SubTaskItemState();
}

class _SubTaskItemState extends State<SubTaskItem> {
  // SubTask? subTask;
  @override
  void initState() {
    // subTask = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.item.id;

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          return ListTile(
            leading: IconButton(
              onPressed: state.currentTask!.subTaskList
                      .firstWhere((element) => element.id == id)
                      .isCompleted
                  ? () {
                      state.currentTask!.subTaskList[state
                              .currentTask!.subTaskList
                              .indexOf(state.currentTask!.subTaskList
                                  .firstWhere((element) => element.id == id))] =
                          state.currentTask!.subTaskList
                              .firstWhere((element) => element.id == id)
                              .copyWith(isCompleted: false);
                      BlocProvider.of<TaskBloc>(context)
                          .add(TaskRefreshEvent());
                      // setState(() {
                      //   subTask = widget.item.copyWith(isCompleted: false);
                      // });
                    }
                  : () {
                      state.currentTask!.subTaskList[state
                              .currentTask!.subTaskList
                              .indexOf(state.currentTask!.subTaskList
                                  .firstWhere((element) => element.id == id))] =
                          state.currentTask!.subTaskList
                              .firstWhere((element) => element.id == id)
                              .copyWith(isCompleted: true);
                      BlocProvider.of<TaskBloc>(context)
                          .add(TaskRefreshEvent());
                      // setState(() {
                      //   subTask = widget.item.copyWith(isCompleted: true);
                      // });
                    },
              icon: state.currentTask!.subTaskList
                      .firstWhere((element) => element.id == id)
                      .isCompleted
                  ? const Icon(Icons.check_box_rounded)
                  : const Icon(Icons.check_box_outline_blank_rounded),
            ),
            title: TextFormField(
              initialValue: '',
              minLines: null,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    decoration: state.currentTask!.subTaskList
                            .firstWhere((element) => element.id == id)
                            .isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationThickness: 1.5,
                  ),
              onChanged: (value) {
                state.currentTask!.subTaskList[state.currentTask!.subTaskList
                    .indexOf(state.currentTask!.subTaskList
                        .firstWhere((element) => element.id == id))] = state
                    .currentTask!.subTaskList
                    .firstWhere((element) => element.id == id)
                    .copyWith(title: value);
              },
              decoration: const InputDecoration(
                hintText: 'Add content',
                border: InputBorder.none,
              ),
            ),
            trailing: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoaded) {
                  return IconButton(
                    onPressed: () {
                      state.currentTask!.subTaskList.removeWhere((element) =>
                          element.id ==
                          state.currentTask!.subTaskList
                              .firstWhere((element) => element.id == id)
                              .id);
                      BlocProvider.of<TaskBloc>(context)
                          .add(TaskRefreshEvent());
                    },
                    icon: const Icon(Icons.close_rounded),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
