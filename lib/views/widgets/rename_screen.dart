import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';

import '../../blocs/appState/appState_cubit.dart';

class RenameScreen extends StatefulWidget {
  const RenameScreen({
    super.key,
    required this.initName,
  });

  final String initName;

  @override
  State<RenameScreen> createState() => _RenameScreenState();
}

class _RenameScreenState extends State<RenameScreen> {
  late String inputName;

  @override
  void initState() {
    super.initState();
    inputName = widget.initName;
  }

  @override
  Widget build(BuildContext context) {
    final appState = BlocProvider.of<AppStateCubit>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rename list'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: inputName.isEmpty
                ? null
                : () {
                  context.read<GroupTaskBloc>().add(UpdateGroupTask(groupTask: appState.currentGroupTask, name: inputName));
                  appState.changeCurrentGroupTask(appState.currentGroupTask.copyWith(name: inputName));
                  Navigator.pop(context);
                },
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            initialValue: inputName,
            onChanged: (value) => setState(() {
              inputName = value;
            }),
            autofocus: true,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter a name',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ],
      ),
    );
  }
}
