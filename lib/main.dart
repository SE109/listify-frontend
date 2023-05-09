import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/routes/app_routes.dart';
import 'package:listify/views/pages/login_page.dart';

import 'blocs/task/task_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => TaskBloc()..add(TaskLoadEvent()),
      child: MaterialApp(
        title: 'Listify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRoutes().getRoute,
        home: const LoginPage(),
      ),
    );
  }
}
