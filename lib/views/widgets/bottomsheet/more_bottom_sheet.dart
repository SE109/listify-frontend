import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/task/task_bloc.dart';
import '../../../models/g_task.dart';
import '../rename_screen.dart';

class MoreBottomSheet extends StatelessWidget {
  const MoreBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if(state is TaskLoaded){
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FunctionItem(
                  title: 'Delete all completed tasks',
                  onPressed: () {
                    Navigator.pop(context);
                    var gTask = GTask(id: -1, name: 'Favorite', taskList: []);
                    if(state.gTaskSelected != 'Favorite') {
                      gTask = state.gTasks.firstWhere(
                          (element) => element.name == state.gTaskSelected);
                    }
                    context
                        .read<TaskBloc>()
                        .add(TaskDeleteAllCompletedTaskEvent(gTask: gTask));
                  },
                ),
                FunctionItem(
                  title: 'Rename list',
                  onPressed: state.gTaskSelected == 'Today' || state.gTaskSelected == 'Favorite'
                      ? null
                      : () {
                        var gTask = state.gTasks.firstWhere((element) => element.name == state.gTaskSelected);
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RenameScreen(
                                    gTask: gTask,
                                  )));
                        },
                ),
                FunctionItem(
                  title: 'Delete list',
                  onPressed: state.gTaskSelected == 'Today' ||
                          state.gTaskSelected == 'Favorite'
                      ? null
                      : () async {
                           var gTask = state.gTasks.firstWhere(
                              (element) => element.name == state.gTaskSelected);
                            Navigator.pop(context);
                            context.read<TaskBloc>().add(
                              TaskDeleteGroupTask(gTask: gTask));
                        },
                ),
              ],
            ),
          );
        }
        else{
          return Container();
        }
      },
    );
  }
}

class FunctionItem extends StatelessWidget {
  const FunctionItem({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
