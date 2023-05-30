import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/task/task_bloc.dart';
import '../../../models/g_task.dart';
import 'list_item.dart';

class DefaultSection extends StatelessWidget {
  const DefaultSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
         final today = state.gTasks.firstWhere(
            (element) => element.name == 'Today',
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListItem(
                id: today.id,
                title: 'Today',
                icon: const Icon(Icons.light_mode_rounded),
                badge: today.taskList.length,
              ),
               ListItem(
                id: -1,
                title: 'Favorites',
                icon: const Icon(Icons.star_border_rounded),
                badge: getFavoritesList(state.gTasks),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
   int getFavoritesList(List<GTask> gTasks) {
    int sum = gTasks.fold(0, (acc, item) {
      return acc + item.taskList.where((task) => task.isFavorited).length;
    });
    return sum;
  }
}
