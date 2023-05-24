import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/user/user_bloc.dart';
import 'package:listify/repositories/user_repository.dart';
import 'package:listify/routes/app_routes.dart';
import 'package:listify/views/pages/drawer/app_drawer.dart';
import 'package:listify/views/pages/home_page.dart';
import 'package:listify/views/pages/login_register/login_page.dart';
import 'package:listify/views/pages/user_profile/profile_page.dart';

import 'blocs/appState/appState_cubit.dart';
import 'blocs/auth/auth_bloc.dart';

import 'blocs/login/login_bloc.dart';
import 'blocs/task/task_bloc.dart';
import 'config/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp(
    userRepository: userRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userRepository});
  final UserRepository userRepository;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc()..add(TaskLoadEvent()),
        ),
        BlocProvider(
            create: (context) => AuthBloc(userRepository)..add(AppStarted())),
        BlocProvider(create: (context) => UserBloc()..add(GetInfo())),
        BlocProvider(
            create: (context) => LoginBloc(
                authBloc: BlocProvider.of<AuthBloc>(context),
                userRepository: userRepository),
                
        ),
        BlocProvider(create: (context) => AppStateCubit()..checkTheme()),
      ],
      child: MaterialApp(
        // title: 'Listify',

        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRoutes().getRoute,
        home: Scaffold(
          drawer: const AppDrawer(),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context1, state) {
              if (state is AuthLoading) {
                return Center(child: const CircularProgressIndicator());
              } else if (state is AuthAuthenticated) {
                // return HomePage();
                // return UpdateProfilePage();
                return HomePage();
                // return Container(child: Center(child: ElevatedButton(child: Text("test"),onPressed: () {
                //   userRepository.refreshToken  ();
                // },)),);
              } else if (state is AuthUnAuthenticated) {
                return LoginPage(
                  userRepository: userRepository,
                );
              } else {
                return Center(child: const CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
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

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
