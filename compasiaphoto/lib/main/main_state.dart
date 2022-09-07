enum PermissionDirect { allowed, denied }

class MainState {
  MainState({required this.permissionStatus});
  final PermissionDirect permissionStatus;

  MainState copyWith(PermissionDirect permissionStatus) {
    return MainState(permissionStatus: permissionStatus);
  }
}
