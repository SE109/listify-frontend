import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';
import 'package:listify/views/widgets/drawer/personal_section.dart';

import 'add_list_bottom_sheet.dart';
import 'default_section.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: BlocBuilder<GroupTaskBloc, GroupTaskState>(
          builder: (context, state) {
            if(state is GroupTaskLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is GroupTaskLoaded) {
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:  [
                          DefaultSection(groupTasks: state.groupTasks),
                          const Divider(
                            thickness: 2,
                            indent: 16,
                            endIndent: 16,
                          ),
                          PersonalSection(
                            title: 'Personal',
                            groupTasks: state.groupTasks
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showAddListBottomSheet(context),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 10,
                      bottom: 10,
                      right: 16,
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add_rounded),
                        SizedBox(width: 8),
                        Text('Add list'),
                      ],
                    ),
                  ),
                ),
              ],
            );
            }
            else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> _showAddListBottomSheet(BuildContext context) {
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
              child: const AddListBottomSheet(),
            );
          },
        );
      },
    );
  }
}
