import 'package:compasiaphoto/main/main_event.dart';
import 'package:compasiaphoto/main/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(permissionStatus: PermissionDirect.denied)) {
    on<PermissionRequestEvent>(_onPermissionRequest);
  }

  Future<void> _onPermissionRequest(
      PermissionRequestEvent event, Emitter<MainState> emitter) async {
    final photoAccessStatus = await Permission.photos.request();
    if (photoAccessStatus.isDenied || photoAccessStatus.isPermanentlyDenied) {
      emitter(state.copyWith(PermissionDirect.denied));
    } else {
      emitter(state.copyWith(PermissionDirect.allowed));
    }
  }
}
