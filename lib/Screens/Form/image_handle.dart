import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../export.dart';

class ImageHandler {
  Future<String?> getImagePath(ImageSource imagesource) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
    final pickedFile = await ImagePicker().pickImage(source: imagesource);
    if (pickedFile != null) {
      final croppedFile = await (ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false)
        ],
      ));
      final fileName = path.basename(croppedFile!.path);
      File file = File(croppedFile.path);
      final dir = await getApplicationDocumentsDirectory();
      final imagedir = await Directory('${dir.path}/$AppName/Product Pictures')
          .create(recursive: true);
      final savedImage = await file.copy('${imagedir.path}/$fileName');
      return savedImage.path;
    } else {
      return null;
    }
  }

  List<String> validimagepath(List<String> pathlist) {
    List<String> valid = [];
    for (String i in pathlist) {
      if (File(i).existsSync()) valid.add(i);
    }
    return valid;
  }

  bool checkimagepath(List<String> imagelist) {
    if (imagelist.length > 0) {
      if (validimagepath(imagelist).length > 0) return true;
    }
    return false;
  }

  List<FileImage> imagefilelist(List<String> pathlist) {
    List<FileImage> image = [];
    for (String i in validimagepath(pathlist)) {
      image.add(FileImage(File(i)));
    }
    return image;
  }
}

class ProductImageHandle extends StatefulWidget {
  final Product product;
  const ProductImageHandle({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductImageHandle> createState() => _ProductImageHandleState();
}

class _ProductImageHandleState extends State<ProductImageHandle> {
  final picker = ImagePicker;
  Directory? appDir;
  String? fileName;
  late File savedImage;
  late Directory imagedir;
  String? appDirs;
  late ImageHandler imgHandler;
  @override
  void didChangeDependencies() {
    imgHandler = ImageHandler();
    super.didChangeDependencies();
  }

  void chooseimage() async {
    String? path = await showModalBottomSheet<String?>(
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: TextButton(
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.asset('assets/camera.png',
                                fit: BoxFit.fill)),
                        Text('Camera')
                      ],
                    ),
                    onPressed: () async {
                      final path =
                          await imgHandler.getImagePath(ImageSource.camera);
                      Navigator.pop(context, path);
                    },
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: TextButton(
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.asset('assets/gallery.png',
                                fit: BoxFit.fill)),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () async {
                      final path =
                          await imgHandler.getImagePath(ImageSource.gallery);
                      Navigator.pop(context, path);
                    },
                  ),
                )
              ],
            ),
          );
        });
    if (path != null) {
      widget.product.imagepathlist.add(path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _imagefiles = widget.product.imagepathlist;
    return Container(
      color: Colors.black26,
      height: 150,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imgHandler.checkimagepath(_imagefiles)
              ? Expanded(
                  flex: (_imagefiles.length == 0) ? 0 : 3,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imgHandler.validimagepath(_imagefiles).length,
                      shrinkWrap: true,
                      itemBuilder: (contect, idx) {
                        return Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1),
                              child: Image.file(
                                  File(imgHandler
                                      .validimagepath(_imagefiles)[idx]),
                                  fit: BoxFit.contain),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () => setState(() {
                                  widget.product.imagepathlist.removeAt(idx);
                                }),
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: EdgeInsets.all(.05),
                                    child: Center(
                                      child: Icon(Icons.close,
                                          size: 20, color: Colors.white),
                                    ),
                                    color: Colors.red.withOpacity(.75)),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
          TextButton(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/add-image.png', fit: BoxFit.fill),
                ),
                (_imagefiles.length > 0)
                    ? Text('Add Product Image', textAlign: TextAlign.center)
                    : Text('Add Product Image')
              ],
            ),
            onPressed: chooseimage,
          ),
        ],
      ),
    );
  }
}
