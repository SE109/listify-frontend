import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/task/task_bloc.dart';
import 'package:listify/models/task.dart';
import 'package:listify/views/widgets/voice_screen.dart';

import 'date_item.dart';
import 'detail_item.dart';
import 'headline_title.dart';
import 'list_selector.dart';
import 'subtasks_item.dart';

class TaskContentScreen extends StatefulWidget {
  const TaskContentScreen({super.key, required this.task});

  final MyTask task;

  @override
  State<TaskContentScreen> createState() => _TaskContentScreenState();
}

class _TaskContentScreenState extends State<TaskContentScreen> {
  late TextEditingController titleEditController;
  late TextEditingController detailEditController;
  @override
  void initState() {
    titleEditController = TextEditingController();
    detailEditController = TextEditingController();

    BlocProvider.of<TaskBloc>(context)
        .add(TaskChangeCurrentEvent(task: widget.task));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final taskContentController = context.watch<TaskContentController>();
    // final completed = taskContentController.completed;
    // final onFavorite = taskContentController.favorite;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VoiceScreen(task: widget.task)));
            },
            icon: const Icon(Icons.keyboard_voice_outlined),
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                var task;
                try {
                  task = state.tasksDisplay.firstWhere(
                    (element) => element.id == widget.task.id,
                  );
                } catch (e) {}
                if (task == null) {
                  return const Icon(Icons.star_rounded);
                }
                return IconButton(
                  onPressed: () {
                    BlocProvider.of<TaskBloc>(context)
                        .add(TaskFavoriteEvent(task: widget.task));
                  },
                  // =>
                  //     taskContentController.updateTask(onFavorite: !onFavorite),
                  icon: task.isFavorited
                      ? const Icon(Icons.star_rounded)
                      : const Icon(Icons.star_border_rounded),
                );
              } else {
                return const Icon(Icons.star_rounded);
              }
            },
          ),
          IconButton(
            onPressed: () async {
              await Future.delayed(
                  const Duration(milliseconds: 300),
                  () => BlocProvider.of<TaskBloc>(context)
                      .add(TaskDeleteEvent()));
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.task.isCompleted
            ? () {
                BlocProvider.of<TaskBloc>(context).add(TaskSaveChangeTaskEvent(
                    detail: detailEditController.text,
                    title: titleEditController.text,
                    toDate: null));
                Navigator.pop(context);
              }
            : () {
                BlocProvider.of<TaskBloc>(context).add(TaskSaveChangeTaskEvent(
                    detail: detailEditController.text,
                    title: titleEditController.text,
                    toDate: null));
                Navigator.pop(context);
              },
        label: widget.task.isCompleted
            ? const Text('Save')
            : const Text('Save'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListSelector(
                task: widget.task,
              ),
              HeadlineTitle(
                task: widget.task,
                textEditingController: titleEditController,
              ),
              DetailItem(
                task: widget.task,
                textEditingController: detailEditController,
              ),
              DateItem(task: widget.task),
              SubtasksItem(task: widget.task),
            ],
          ),
        ),
      ),
    );
  }
}
