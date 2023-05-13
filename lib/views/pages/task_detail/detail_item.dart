import 'package:flutter/material.dart';
import 'package:listify/models/task.dart';
import 'package:provider/provider.dart';

class DetailItem extends StatelessWidget {
  const DetailItem({
    Key? key,
    required this.task,
    required this.textEditingController,
  }) : super(key: key);

  final Task task;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_rounded),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: textEditingController..text = task.description,
              // initialValue: task.description,
              onChanged: (value) {},
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Add details',
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                contentPadding: EdgeInsets.zero,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
