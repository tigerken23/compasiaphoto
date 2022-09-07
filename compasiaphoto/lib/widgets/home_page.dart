import 'dart:math';

import 'package:compasiaphoto/models/gallery_model.dart';
import 'package:compasiaphoto/home/home_bloc.dart';
import 'package:compasiaphoto/home/home_event.dart';
import 'package:compasiaphoto/home/home_state.dart';
import 'package:compasiaphoto/widgets/gallery_selections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MyHomePage());
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late final HomeBloc _bloc;
  FocusNode inputNode = FocusNode();
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Photos Keyboard',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.isSelectedPhoto) {
                FocusManager.instance.primaryFocus?.unfocus();
              } else {
                FocusScope.of(context).requestFocus(inputNode);
              }
            },
            bloc: _bloc,
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        thickness: 0.2,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          focusNode: inputNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Jot something down',
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.zero,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<HomeBloc, HomeState>(
                                builder: ((context, state) {
                                  return IconButton(
                                    iconSize: 24,
                                    icon: Icon(
                                      Icons.photo_camera_back,
                                      color: state.isSelectedPhoto
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      inputNode.unfocus();
                                      _bloc.add(GallerySelectionChange());
                                    },
                                  );
                                }),
                              ),
                              IconButton(
                                iconSize: 24,
                                icon: const Icon(
                                  Icons.photo_camera,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: ((context, state) {
                          if (!state.isEmptySelectedImages) {
                            return _selectedImageWidget(state.selectedImages);
                          }
                          return Container();
                        }),
                      ),
                      Focus(
                        focusNode: inputNode,
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            _height = MediaQuery.of(context).viewInsets.bottom;
                          }
                          _bloc.add(
                              FocusChangeEvent(height: hasFocus ? 250 : 0));
                        },
                        child: BlocBuilder<HomeBloc, HomeState>(
                            builder: ((context, state) {
                          if (state.isSelectedPhoto) {
                            return Container(
                              height: max(250, _height),
                              margin: EdgeInsets.zero,
                              child: GallerySelectionWidget(
                                didSelectImage: (galleryImage) {
                                  _bloc.add(
                                      GalleryImageChange(image: galleryImage));
                                },
                              ),
                            );
                          }
                          return Builder(builder: (context) {
                            return Container(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom);
                          });
                        })),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _selectedImageWidget(List<GalleryImage> selectedImages) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return _selectedImageItem(selectedImages[index]);
        }),
        itemCount: selectedImages.length,
      ),
    );
  }

  Widget _selectedImageItem(GalleryImage item) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageFromItem(item),
            ),
          ),
          Positioned(
            top: -14,
            right: -14,
            child: IconButton(
              iconSize: 24,
              icon: const Icon(
                Icons.cancel_rounded,
              ),
              onPressed: () {
                _bloc.add(GalleryImageChange(image: item));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget? imageFromItem(GalleryImage item) {
    if (item.bytes != null) {
      return Image.memory(
        item.bytes!,
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
