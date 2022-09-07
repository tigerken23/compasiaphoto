import 'package:compasiaphoto/models/gallery_model.dart';
import 'package:compasiaphoto/app/injection_container.dart';
import 'package:flutter/material.dart';

class GallerySelectionWidget extends StatefulWidget {
  GallerySelectionWidget({super.key, this.didSelectImage});
  final Function(GalleryImage)? didSelectImage;
  @override
  State<GallerySelectionWidget> createState() => _GallerySelectionWidgetState();
}

class _GallerySelectionWidgetState extends State<GallerySelectionWidget> {
  var _itemCache = Map<int, GalleryImage>();
  var _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _getTotalImages();
  }

  Future<GalleryImage> _getItem(int index) async {
    if (_itemCache[index] != null) {
      return _itemCache[index]!;
    } else {
      var channelResponse = await platform.invokeMethod("getItem", index);
      var item = Map<String, dynamic>.from(channelResponse);
      var galleryImage = GalleryImage(
          bytes: item['data'],
          id: item['id'],
          dateCreated: item['created'],
          location: item['location']);
      _itemCache[index] = galleryImage;
      return galleryImage;
    }
  }

  Future<void> _getTotalImages() async {
    final totalImages = await platform.invokeMethod('getTotalImages');
    setState(() {
      _totalItems = totalImages;
    });
  }

  void _selectItem(int index) async {
    var galleryImage = await _getItem(index);
    widget.didSelectImage!(galleryImage);
  }

  _buildItem(int index) => GestureDetector(
      onTap: () {
        if (widget.didSelectImage != null) {
          _selectItem(index);
        }
      },
      child: Card(
        elevation: 2.0,
        child: FutureBuilder(
            future: _getItem(index),
            builder: (context, snapshot) {
              var item = snapshot.data;
              if (item != null && item.bytes != null) {
                return Image.memory(item.bytes!, fit: BoxFit.cover);
              }

              return Container();
            }),
      ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        itemCount: _totalItems,
        scrollDirection: Axis.horizontal,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: ((context, index) {
          return _buildItem(index);
        }),
      ),
    );
  }
}
