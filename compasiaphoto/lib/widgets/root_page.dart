import 'package:compasiaphoto/app/injection_container.dart';
import 'package:compasiaphoto/main/main_bloc.dart';
import 'package:compasiaphoto/main/main_event.dart';
import 'package:compasiaphoto/main/main_state.dart';
import 'package:compasiaphoto/app/navigation_service.dart';
import 'package:compasiaphoto/widgets/splash.dart';
import 'package:compasiaphoto/widgets/home_page.dart';
import 'package:compasiaphoto/widgets/permission_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRootView extends StatefulWidget {
  AppRootView({super.key});

  @override
  State<AppRootView> createState() => _AppRootViewState();
}

class _AppRootViewState extends State<AppRootView> {
  final _navigatorKey = sl<NavigationService>().navigatorKey;
  NavigatorState get _navigator => _navigatorKey.currentState!;
  late MainBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MainBloc>(context);
    _bloc.add(PermissionRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        builder: ((context, child) {
          return BlocListener<MainBloc, MainState>(
            listener: ((context, state) {
              if (state.permissionStatus == PermissionDirect.allowed) {
                _navigator.push(MyHomePage.route());
              } else {
                _navigator.push(PermissionRequestPage.route());
              }
            }),
            bloc: _bloc,
            child: child,
          );
        }),
        onGenerateRoute: (_) => SplashPage.route());
  }
}
