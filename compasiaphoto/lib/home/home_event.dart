import 'package:compasiaphoto/models/gallery_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class RemoveSelectedImage extends HomeEvent {
  RemoveSelectedImage({required this.image});
  final GalleryImage image;

  @override
  List<Object?> get props => [image];
}

class GalleryImageChange extends HomeEvent {
  GalleryImageChange({required this.image});
  final GalleryImage image;

  @override
  List<Object?> get props => [image];
}

class GallerySelectionChange extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class FocusChangeEvent extends HomeEvent {
  FocusChangeEvent({required this.height});
  final double height;

  @override
  List<Object?> get props => [height];
}
