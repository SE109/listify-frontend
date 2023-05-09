import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/appState/appState_cubit.dart';
import 'package:listify/blocs/group_task/group_task_bloc.dart';
import 'package:listify/routes/app_routes.dart';
import 'package:listify/styles/themes.dart';
import 'package:listify/views/widgets/navigating_point.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppStateCubit()..checkTheme()),
        BlocProvider(create: (context) => GroupTaskBloc()..add(GetAllGroupTasks()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<AppStateCubit>(context , listen: true);
    return MaterialApp(
      title: 'Listify',
      debugShowCheckedModeBanner: false,
      theme: getTheme(themeCubit),
      onGenerateRoute: AppRoutes().getRoute,
      home: const NavigatingPoint(),
    );
  }
  
  ThemeData? getTheme(AppStateCubit themeCubit) {
    if(themeCubit.theme == 'light'){
      return AppTheme.lightTheme;
    }
    else if (themeCubit.theme == 'dark') {
      return AppTheme.darkTheme;
    } 
    return null;
  }
}

