import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/repositories/user_repository.dart';
import 'package:listify/routes/app_routes.dart';
import 'package:listify/views/pages/home_page.dart';
import 'package:listify/views/pages/login_page.dart';
import 'package:listify/views/pages/profile_page.dart';
import 'package:listify/views/pages/update_profile_page.dart';

import 'blocs/auth/auth_bloc.dart';

void main() {
  final UserRepository userRepository= UserRepository();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(userRepository: userRepository,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userRepository});
  final UserRepository userRepository;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(userRepository)..add(AppStarted()),
      child: MaterialApp(
        title: 'Listify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRoutes().getRoute,
        home: Scaffold(
          body: BlocBuilder<AuthBloc,AuthState>(
            builder: (context1, state) {
              if(state is AuthLoading){
                return const CircularProgressIndicator();
              }
              else if(state is AuthAuthenticated){
                return HomePage(userRepository: userRepository,);
                // return UpdateProfilePage();
              }
              else if(state is AuthUnAuthenticated){
                return LoginPage(userRepository: userRepository,);
              }
              else{
                return const CircularProgressIndicator();
              }
          },),
        ),
      ),
    );
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
