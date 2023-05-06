import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/add_task_bottomsheet.dart';
import '../widgets/more_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            title: Text('Listify'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
            actions: [
              IconButton(
                onPressed: () => _showMoreBottomSheet(context),
                icon: const Icon(Icons.more_horiz_rounded),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container()

                  // GestureDetector(
                  //   onTap: () => showSearch(
                  //     context: context,
                  //     delegate: TaskSearchDelegate(),
                  //   ),
                  //   child: const SearchBar(),
                  // ),
                  ),
            ),
          ),
          // if (currentListId == 'today')
          //   const TodayListBody()
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
