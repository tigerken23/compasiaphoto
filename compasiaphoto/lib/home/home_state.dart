import 'package:compasiaphoto/models/gallery_model.dart';

enum ListImageStatus { initialize, added, removed }

class HomeState {
  HomeState(
      {required this.selectedImages,
      required this.listImageStatus,
      required this.isSelectedPhoto});
  List<GalleryImage> selectedImages;
  ListImageStatus listImageStatus;
  bool isSelectedPhoto;
  double height = 0;

  bool isSelected(String id) {
    return selectedImages.where((item) => item.id == id).isNotEmpty;
  }

  bool get isEmptySelectedImages {
    return selectedImages.isEmpty;
  }

  HomeState copyWith(
      {ListImageStatus? status,
      List<GalleryImage>? selectedImages,
      bool? isSelectedPhoto}) {
    final newState = HomeState(
        selectedImages: selectedImages ?? this.selectedImages,
        listImageStatus: status ?? listImageStatus,
        isSelectedPhoto: isSelectedPhoto ?? this.isSelectedPhoto);
    return newState;
  }
}
