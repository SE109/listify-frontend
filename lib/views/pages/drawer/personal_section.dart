import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/models/g_task.dart';
import 'package:listify/models/tasklist.dart';

import '../../../blocs/task/task_bloc.dart';
import 'list_item.dart';

class PersonalSection extends StatelessWidget {
  const PersonalSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    // final controller = context.watch<TaskListsController>();
    // final taskLists = controller.tasklists;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoaded) {
              final List<TaskList> gTaskList = state.gTasks
                  .map((e) => TaskList(id: e.id, name: e.name))
                  .toList();
              gTaskList.removeWhere((element) => element.name == 'Today');
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gTaskList.length,
                itemBuilder: (context, index) {
                  final badge = getBadge(gTaskList[index].id , state.gTasks);
                  return ListItem(
                    id: gTaskList[index].id,
                    icon: const Icon(Icons.note_rounded),
                    title: gTaskList[index].name,
                    badge: badge,
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }

  getBadge(int id, List<GTask> gTasks) {
    return gTasks.firstWhere((element) => element.id == id).taskList.length;
  }
}
