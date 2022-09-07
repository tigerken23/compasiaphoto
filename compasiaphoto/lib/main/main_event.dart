import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {}

class PermissionRequestEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}
