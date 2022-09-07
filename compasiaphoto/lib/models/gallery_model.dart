import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class GalleryImage extends Equatable {
  Uint8List? bytes;
  String id;
  int dateCreated;
  String location;

  GalleryImage({
    required this.bytes,
    required this.id,
    required this.dateCreated,
    required this.location,
  });

  @override
  List<Object?> get props => [id, dateCreated, bytes, location];
}
