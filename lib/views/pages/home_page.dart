import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/task/task_bloc.dart';
import '../../models/g_task.dart';
import '../../models/task.dart';
import '../widgets/bottomsheet/add_task_bottomsheet.dart';
import '../widgets/bottomsheet/more_bottom_sheet.dart';
import 'drawer/app_drawer.dart';
import 'today_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<TaskBloc>(context).add(TaskLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskBottomSheet(context, 'uid'),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: false,
            elevation: 0,
            title: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoaded) {
                  return Text(state.gTaskSelected == 'Today'
                      ? 'General'
                      : state.gTaskSelected);
                } else {
                  return const Text('Listify');
                }
              },
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(Icons.menu),
            ),
            actions: [
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    return IconButton(
                      onPressed: () => _showMoreBottomSheet(context),
                      icon: const Icon(Icons.more_horiz_rounded),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz_rounded),
                    );
                  }
                },
              )
            ],
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(75),
            //   child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 16,
            //         vertical: 8,
            //       ),
            //       child: Container()

            //       // GestureDetector(
            //       //   onTap: () => showSearch(
            //       //     context: context,
            //       //     delegate: TaskSearchDelegate(),
            //       //   ),
            //       //   child: const SearchBar(),
            //       // ),
            //       ),
            // ),
          ),
          // if (currentListId == 'today')
          const TodayListBody()
          // else if (currentListId == 'favorites')
          //   const FavoritesListBody()
          // else
          //   const PersonalListBody()
        ],
      ),
    );
  }

  Future<dynamic> _showMoreBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      enableDrag: false,
      builder: (context) {
        return BottomSheet(
          enableDrag: false,
          onClosing: () {},
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: const MoreBottomSheet(),
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showAddTaskBottomSheet(BuildContext context, String listId) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) {
        // return Container(
        //     padding: EdgeInsets.only(
        //         bottom: MediaQuery.of(context).viewInsets.bottom),
        //     child: AddTaskBottomSheet(listId: listId));
        return BottomSheet(
          enableDrag: false,
          onClosing: () {},
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTaskBottomSheet(listId: listId),
            );
          },
        );
      },
    );
  }
}
