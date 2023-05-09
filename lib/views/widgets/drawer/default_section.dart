import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';
import 'package:listify/models/group_task.dart';
import 'package:listify/models/task.dart';

import 'list_item.dart';

class DefaultSection extends StatelessWidget {
  const DefaultSection({
    Key? key, required this.groupTasks,
  }) : super(key: key);
  final List<GroupTask> groupTasks;
  @override
  Widget build(BuildContext context) {
    final listFavorites = getFavortiesList(groupTasks);
    final listToday = getTodayList(groupTasks); 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListItem(
          groupTask: GroupTask(id: -1, name: "Today", taskList: listToday),
          icon: const Icon(Icons.light_mode_rounded),
          badge: listToday.length,
        ),
        ListItem(
          groupTask:
              GroupTask(id: 0, name: "Favorites", taskList: listFavorites),
          icon: const Icon(Icons.star_border_rounded),
          badge: listFavorites.length,
        ),
      ],
    );
  }
  
  getFavortiesList(List<GroupTask> groupTasks) {
    var fav = <Task>[];
    groupTasks.forEach((gt) { 
      gt.taskList!.forEach((t) { 
        if(t.isFavorited! ) {
          fav.add(t);
        }
      });
    });
    return fav;
  }
  
  getTodayList(List<GroupTask> groupTasks) {
     var fav = <Task>[];
    groupTasks.forEach((gt) {
      gt.taskList!.forEach((t) {
        final today = DateTime.now();
        final fromDate = DateTime.parse(t.fromDate!);
        final toDate = DateTime.parse(t.toDate!);
        if (today.isAfter(fromDate) && today.isBefore(toDate)) {
          fav.add(t);
        }
      });
    });
    return fav;
  }
}
