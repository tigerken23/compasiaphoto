import 'package:compasiaphoto/home/home_bloc.dart';
import 'package:compasiaphoto/main/main_bloc.dart';
import 'package:compasiaphoto/app/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
const platform = MethodChannel('compasia.interview.com/photo');
void init() {
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => MainBloc());
  sl.registerLazySingleton(() => NavigationService());
}
