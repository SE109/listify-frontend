import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';

import '../../../models/group_task.dart';
import 'list_item.dart';

class PersonalSection extends StatelessWidget {
  const PersonalSection({
    Key? key,
    required this.title, 
    required this.groupTasks,
  }) : super(key: key);

  final String title;
  final List<GroupTask> groupTasks;
  @override
  Widget build(BuildContext context) {
    groupTasks.sort((a, b) => a.id!.compareTo(b.id!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupTasks.length,
          itemBuilder: (context, index) {
            return ListItem(
              groupTask: groupTasks[index],
              icon: const Icon(Icons.note_rounded),
              badge: groupTasks[index].taskList!.length,
            );
          },
        )
      ],
    );
  }
}
