import 'package:flutter/material.dart';
import 'package:listify/models/task.dart';
import 'package:provider/provider.dart';

import '../widgets/progress_section.dart';

class TodayListBody extends StatelessWidget {
  const TodayListBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ProgressSection(tasks: []),
          // CompletedSection(tasks: tasks),
        ],
      ),
    );
  }
}
