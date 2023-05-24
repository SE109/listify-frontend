
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appState/appState_cubit.dart';
import '../progress_section.dart';


class PersonalListBody extends StatelessWidget {
  const PersonalListBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final appStateCubit = BlocProvider.of<AppStateCubit>(context, listen: true);
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ProgressSection(tasks: appStateCubit.currentGroupTask.taskList!),
          // CompletedSection(tasks: tasks),
        ],
      ),
    );
  }
}
