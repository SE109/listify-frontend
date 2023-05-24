import 'package:flutter/material.dart';
import 'package:listify/models/task.dart';
import 'package:provider/provider.dart';

class HeadlineTitle extends StatelessWidget {
  const HeadlineTitle({
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
        top: 8,
        bottom: 8,
        right: 16,
      ),
      child: TextFormField(
        controller: textEditingController..text = task.title,
        // initialValue: task.title,
        onChanged: (value) {},
        style: Theme.of(context).textTheme.headlineMedium,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Enter a title',
          hintStyle: Theme.of(context).textTheme.headlineMedium,
          contentPadding: EdgeInsets.zero,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
