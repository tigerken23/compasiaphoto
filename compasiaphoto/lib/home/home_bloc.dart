import 'package:compasiaphoto/models/gallery_model.dart';
import 'package:compasiaphoto/home/home_event.dart';
import 'package:compasiaphoto/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(HomeState(
            selectedImages: [],
            listImageStatus: ListImageStatus.initialize,
            isSelectedPhoto: false)) {
    on<GalleryImageChange>(_onGalleryImageChange);
    on<GallerySelectionChange>(_onGallerySelectionChange);
    on<FocusChangeEvent>(_onFocusChangeEvent);
  }

  void _onFocusChangeEvent(FocusChangeEvent event, Emitter<HomeState> emitter) {
    final newState = state.copyWith();
    newState.height = event.height;
    emitter(newState);
  }

  void _onGalleryImageChange(
      GalleryImageChange event, Emitter<HomeState> emitter) {
    ListImageStatus status;
    List<GalleryImage> images = state.selectedImages;
    if (state.isSelected(event.image.id)) {
      images.removeWhere((anItem) => anItem.id == event.image.id);
      status = ListImageStatus.removed;
    } else {
      images.add(event.image);
      status = ListImageStatus.added;
    }

    final newState = state.copyWith(selectedImages: images, status: status);
    emitter(newState);
  }

  void _onGallerySelectionChange(
      GallerySelectionChange event, Emitter<HomeState> emitter) {
    final isSelectedPhoto = !state.isSelectedPhoto;
    emitter(state.copyWith(isSelectedPhoto: isSelectedPhoto));
  }
}
