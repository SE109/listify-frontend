import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/utils/format_utils.dart';
import 'package:provider/provider.dart';

import '../../../blocs/task/task_bloc.dart';
import '../../../models/task.dart';

class DateItem extends StatefulWidget {
  const DateItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final MyTask task;

  @override
  State<DateItem> createState() => _DateItemState();
}

class _DateItemState extends State<DateItem> {
  DateTime? date;
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
  void initState() {
    date = widget.task.toDate;
    super.initState();
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
          date != null
              ? InputChip(
                  label: Text(
                    FormatUtils.formatTaskDetailDateTime(date!),
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  onDeleted: () {
                    setState(() {
                      date = null;
                    });
                  },
                )
              : BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: GestureDetector(
                          onTap: () async {
                            date = await _showDatePicker(context);
                            setState(() {});
                            state.currentTask = state.currentTask!.copyWith(toDate: date);
                          },
                          child: Text(
                            'Add date',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
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
