
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/task.dart';

class DateItem extends StatelessWidget {
  const DateItem({
    Key? key, required this.task,
  }) : super(key: key);

  final Task task;

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(3000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 24,
      ),
      child: Row(
        children: [
          const Icon(Icons.today_rounded),
          const SizedBox(width: 16),
          task.toDate != null
              ? InputChip(
                  label: Text(
                    task.fromDate.toLocal().toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  onDeleted: () {},
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: GestureDetector(
                    onTap: () async {
                    },
                    child: Text(
                      'Add date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
