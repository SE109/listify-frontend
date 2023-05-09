import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';
import 'package:listify/views/widgets/rename_screen.dart';

import '../../blocs/appState/appState_cubit.dart';

class MoreBottomSheet extends StatelessWidget {
  const MoreBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = BlocProvider.of<AppStateCubit>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FunctionItem(
            title: 'Delete all completed tasks',
            onPressed: () {},
          ),
          FunctionItem(
            title: 'Rename list',
            onPressed: appState.currentGroupTask.id == -1 ||
                    appState.currentGroupTask.id == 0
                ? null
                : () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RenameScreen(
                            initName: appState.currentGroupTask.name!),
                      ),
                    );
                  },
          ),
          FunctionItem(
            title: 'Delete list',
            onPressed: appState.currentGroupTask.id == -1 ||
                    appState.currentGroupTask.id == 0
                ? null
                : () async {
                    Navigator.pop(context);
                    context.read<GroupTaskBloc>().add(
                        DeleteGroupTask(groupTask: appState.currentGroupTask));
                    appState.changeCurrentGroupTask(await appState.todayTask());
                  },
          ),
        ],
      ),
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
