import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Subtasks'),
        task.subTaskList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: task.subTaskList.length,
                  itemBuilder: (_, index) => SubTaskItem(
                    item: task.subTaskList[index],
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton(
            onPressed: () {},
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
  }
}

class SubTaskItem extends StatelessWidget {
  const SubTaskItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SubTask item;

  @override
  Widget build(BuildContext context) {
    final id = item.id;

    return ListTile(
      leading: IconButton(
        onPressed: true ? () {} : () {},
        icon: true
            ? const Icon(Icons.check_box_rounded)
            : const Icon(Icons.check_box_outline_blank_rounded),
      ),
      title: TextFormField(
        initialValue: 'init',
        minLines: null,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: true ? TextDecoration.lineThrough : null,
              decorationThickness: 1.5,
            ),
        onChanged: (value) {},
        decoration: const InputDecoration(
          hintText: 'Add content',
          border: InputBorder.none,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
