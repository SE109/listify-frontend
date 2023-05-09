import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/views/widgets/more_bottom_sheet.dart';
import 'package:listify/views/widgets/today_list/today_list_body.dart';

import '../../blocs/appState/appState_cubit.dart';
import '../widgets/personal_list/personal_list_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState  =  BlocProvider.of<AppStateCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _showAddTaskBottomSheet(context, appState.currentGroupTask.id!),
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
            title: Text(appState.currentGroupTask.name!),
            centerTitle: true,
            leading: IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(Icons.menu),
            ),
            actions: [
              IconButton(
                onPressed: () => _showMoreBottomSheet(context),
                icon: const Icon(Icons.more_horiz_rounded),
              )
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(75),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // child: GestureDetector(
                //   onTap: () => showSearch(
                //     context: context,
                //     delegate: TaskSearchDelegate(),
                //   ),
                //   child: const SearchBar(),
                // ),
              ),
            ),
          ),
          if (appState.currentGroupTask.id == -1)
             const TodayListBody()
          else if (appState.currentGroupTask.id == 0)
             const SliverToBoxAdapter()
          else
            const PersonalListBody()
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
              child: const MoreBottomSheet()
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showAddTaskBottomSheet(BuildContext context, int listId) {
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
              child: Container(),
            );
          },
        );
      },
    );
  }
}
