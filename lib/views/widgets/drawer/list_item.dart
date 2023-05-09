// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appState/appState_cubit.dart';
import '../../../models/group_task.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.groupTask,
    this.badge = 0,
    required this.icon,
  }) : super(key: key);

  final GroupTask groupTask;
  final int badge;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
     final appStateCubit = BlocProvider.of<AppStateCubit>(context, listen: false);

    return GestureDetector(
      onTap: () {
        appStateCubit.changeCurrentGroupTask(groupTask);
        Scaffold.of(context).closeDrawer();
      },
      child: Container(
        decoration: BoxDecoration(
          color: appStateCubit.currentGroupTask.id == groupTask.id
              ? Theme.of(context).colorScheme.secondaryContainer
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 16,
            right: 24,
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  groupTask.name!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${badge > 99 ? '99+' : badge}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
