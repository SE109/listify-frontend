import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/task/task_bloc.dart';
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
          final todayId = state.gTasks
              .firstWhere(
                (element) => element.name == 'Today',
              )
              .id;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListItem(
                id: todayId,
                title: 'Today',
                icon: Icon(Icons.light_mode_rounded),
                badge: 0,
              ),
              const ListItem(
                id: -1,
                title: 'Favorites',
                icon: Icon(Icons.star_border_rounded),
                badge: 0,
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
