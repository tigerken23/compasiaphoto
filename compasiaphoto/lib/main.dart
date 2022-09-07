import 'dart:ffi';
import 'package:compasiaphoto/home/home_bloc.dart';
import 'package:compasiaphoto/app/injection_container.dart';
import 'package:compasiaphoto/main/main_bloc.dart';
import 'package:compasiaphoto/widgets/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/injection_container.dart' as di;

void main() {
  di.init();
  BlocOverrides.runZoned(() => {runApp(const MyApp())},
      blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => sl<HomeBloc>())),
        BlocProvider(create: ((context) => sl<MainBloc>())),
      ],
      child: AppRootView(),
    );
  }
}

class AppBlocObserver extends BlocObserver {}
