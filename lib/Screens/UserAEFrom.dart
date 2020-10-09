import 'package:flutter/material.dart';
import '../Tool/DynamicTextField.dart';
import '../Provider/CategoryDataP.dart';
import 'package:provider/provider.dart';
import '../Tool/MultiSelectedChip.dart';
import '../Models/ProductModel.dart';
import '../Provider/ProductDataP.dart';
import '../Models/VarietyProductModel.dart';
import '../Provider/VarietyDataP.dart';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as pPath;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'dart:typed_data';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'dart:ui' as ui;

class UserAEForm extends StatefulWidget {
  static const routeName = '/user-AE-Form';

  @override
  _UserAEFormState createState() => _UserAEFormState();
}

class _UserAEFormState extends State<UserAEForm> {
  String currentText = "";
  GlobalKey key = new GlobalKey();
  List<String> _imagefiles = [];
  SnackBar snackBar;
  final picker = ImagePicker;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController _textcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _rankcontroller = TextEditingController();
  TextEditingController _desccontroller = TextEditingController();
  TextEditingController _brandcontroller = TextEditingController();
  List<String> suggestions;
  var edit = false;
  final form = GlobalKey<FormState>();
  var _init = true;
  List<VarietyProductM> varietymodel = [];
  List<String> categoryselected = [];
  var _product = ProductModel(
      id: UniqueKey().toString(),
      name: null,
      imagepathlist: null,
      brand: null,
      description: null,
      categorylist: null);

  @override
  void didChangeDependencies() {
    if (_init) {
      final _prodid = ModalRoute.of(context).settings.arguments as String;
      if (_prodid != null) {
        edit = true;
        _product = Provider.of<ProductData>(context).findbyid(_prodid);
        varietymodel = Provider.of<VarietyData>(context).findbyid(_prodid);
        categoryselected = Provider.of<CategoryData>(context)
            .findcategorylist(_product.categorylist);
        _namecontroller.text = _product.name;
        _rankcontroller.text = _product.rank.toString();
        _imagefiles = _product.imagepathlist;
        _desccontroller.text = _product.description;
        _brandcontroller.text = _product.brand;
      }
    }
    if (_imagefiles == null) {
      _imagefiles = [];
    }
    _init = false;
    suggestions = Provider.of<ProductData>(context).brandlist();
    if (varietymodel.length == 0) {
      varietymodel.add(VarietyProductM(
          productid: _product.id,
          id: null,
          varityname: null,
          price: 0,
          wsp: 0));
    }
    super.didChangeDependencies();
  }

  Widget _exitwithoutvariety(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Atleast Add One Variety',
      ),
      actions: [
        RaisedButton(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _saveform(BuildContext context) {
    final isValid = form.currentState.validate();
    if (varietymodel.length <= 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _exitwithoutvariety(context));
    } else {
      if (!isValid) {
        return;
      }
      for (var i in varietymodel) {
        if (i.price.isNaN || i.price == null) {
          i.price = 0;
        }
        if (i.wsp.isNaN || i.wsp == null) {
          i.wsp = 0;
        }
      }
      form.currentState.save();
      // key.currentState.
      if (_product.categorylist == null || _product.categorylist == []) {
        _product.categorylist = ['otherid'];
      }
      if (edit) {
        Provider.of<ProductData>(context, listen: false)
            .editproduct(_product.id, _product);
        Provider.of<VarietyData>(context, listen: false)
            .editvariety(varietymodel);
        edit = false;
      } else {
        Provider.of<ProductData>(context, listen: false).addproduct(_product);
        Provider.of<VarietyData>(context, listen: false)
            .addvariety(varietymodel);
      }
      Navigator.of(context).pop();
    }
  }

  void deletewidget(int index) {
    setState(() {
      varietymodel = List.from(varietymodel)..removeAt(index);
    });
  }

  void _submitdata() {
    setState(() {
      if (_textcontroller.text.isEmpty) {
        return;
      }
      Provider.of<CategoryData>(context, listen: false)
          .addcategory(_textcontroller.text);
      Navigator.pop(context, true);
      _textcontroller.text = '';
    });
  }

  void _startaddingcat(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Category Name'),
                  controller: _textcontroller,
                  onSubmitted: (_) => _submitdata,
                ),
                RaisedButton(
                    onPressed: _submitdata, child: Text('Add New Category')),
              ],
            ),
          );
        });
  }

  List<String> validimagepath(List<String> pathlist) {
    List<String> valid = [];
    for (String i in pathlist) {
      if (File(i).existsSync()) {
        valid.add(i);
      }
    }
    return valid;
  }

  bool checkimagepath(List<String> imagelist) {
    if (imagelist == null) {
      return false;
    } else {
      if (imagelist.length > 0) {
        if (validimagepath(imagelist).length > 0) {
          return true;
        }
      }
      return false;
    }
  }

  Directory appDir;
  String fileName;
  File savedImage;
  Directory imagedir;
  String appDirs;
  Future getImage(ImageSource imagesource) async {
        appDirs = await ExtStorage.getExternalStorageDirectory();
    var status = await Permission.storage.status;
                  if (!status.isGranted) 
                    await Permission.storage.request();        
        imagedir = await Directory('$appDirs/Product E-catalogue/Product Pictures')
        .create(recursive: true);
    final pickedFile = await ImagePicker().getImage(source: imagesource);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      );
      fileName = path.basename(croppedFile.path);
      File file = File(croppedFile.path);
      savedImage = await file.copy('${imagedir.path}/$fileName');
      _imagefiles.add(savedImage.path);
      _product.updateimageurl(_imagefiles);
      snackBar = SnackBar(content: Text('Image Uploaded Succesfully..!'));
    } else {
      snackBar = SnackBar(content: Text('No Image Selected Yet..!'));
    }
    setState(() {});
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }


  void chooseimage(BuildContext context) {
    showModalBottomSheet(
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
                  child: FlatButton(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/camera.png',
                          fit: BoxFit.fill,
                        ),
                        Text('Camera')
                      ],
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: FlatButton(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/gallery.png',
                          fit: BoxFit.fill
                        ),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categorylist = [];
    final categoryitems =
        Provider.of<CategoryData>(context, listen: true).items;
    for (var i in categoryitems) {
      categorylist.add(i.name);
    }

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: (edit) ? Text('Edit Product') : Text("Add Product"),
      ),
      body: Form(
        key: form,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Container(
              color: Colors.black26,
              height: 150,
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  checkimagepath(_imagefiles)
                      ? Expanded(
                          flex: (_imagefiles == null) ? 0 : 3,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            color: Colors.white,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: validimagepath(_imagefiles).length,
                              shrinkWrap: true,
                              itemBuilder: (contect, idx) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      child: Image.file(
                                        File(validimagepath(_imagefiles)[idx]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        padding: EdgeInsets.all(.05),
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.all(.1),
                                            icon: Icon(Icons.close,
                                                size: 15, color: Colors.white),
                                            onPressed: () {
                                              _imagefiles.removeAt(idx);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  FlatButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/add-image.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        (_imagefiles == null)
                            ? Text('Add Product Image')
                            : (_imagefiles.length > 0)
                                ? Text(
                                    'Add Image',
                                    textAlign: TextAlign.center,
                                  )
                                : Text('Add Product Image')
                      ],
                    ),
                    onPressed: () {
                      chooseimage(context);
                      setState(() {});
                    },
                  ),
                  // ),
                ],
              ),
            ),
            TextFormField(
              controller: _namecontroller,
              decoration: InputDecoration(
                labelText: 'Product Name *',
              ),
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (_) {},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onChanged: (value) {
                _product.updatename(value);
              },
            ),
            TextFormField(
              controller: _desccontroller,
              decoration: InputDecoration(labelText: 'Product Details'),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              // onFieldSubmitted: (_) {},
              onChanged: (value) {
                _product.updatedescription(value);
              },
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: TypeAheadField(
                      key: key,
                      textFieldConfiguration: TextFieldConfiguration(
                          onChanged:
                              // onSubmitted:
                              (value) {
                            _product.updatebrand(value);
                          },
                          controller: _brandcontroller,
                          decoration: InputDecoration(labelText: 'Brand Name')),
                      suggestionsCallback: (pattern) {
                        return suggestions.where((s) =>
                            s.toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return Container(
                          child: Text(
                            suggestion,
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                          color: Colors.white,
                        );
                      },
                      hideSuggestionsOnKeyboardHide: true,
                      getImmediateSuggestions: true,
                      onSuggestionSelected: (suggestion) {
                        _brandcontroller.text = suggestion;
                        _product.updatebrand(_brandcontroller.text);
                        print(_brandcontroller.text);
                      },
                    ),
                    //     TextFormField(
                    //   controller: _brandcontroller,
                    //   decoration: InputDecoration(
                    //     labelText: 'Brand',
                    //   ),
                    //   textInputAction: TextInputAction.next,
                    //   onFieldSubmitted: (_) {},
                    //   onChanged: (value) {
                    //     _product.updatebrand(value);
                    //   },
                    // ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _rankcontroller,
                      decoration: InputDecoration(
                        labelText: 'Rank',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {},
                      onChanged: (value) {
                        _product.updaterank(int.parse(value));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              color: Colors.grey[250],
              child: Column(
                children: <Widget>[
                  (categorylist.length == 0)
                      ? Text('No Category Available')
                      : Text('Select Product Category'),
                  Divider(),
                  Container(
                    child: MultiSelectChip(categorylist, categoryselected,
                        onSelectionChanged: (value) {
                      _product = ProductModel(
                        id: _product.id,
                        name: _product.name,
                        imagepathlist: _product.imagepathlist,
                        brand: _product.brand,
                        description: _product.description,
                        categorylist:
                            Provider.of<CategoryData>(context, listen: false)
                                .findcategoryidlist(value),
                      );
                    }),
                  ),
                  RaisedButton(
                    onPressed: () => _startaddingcat(context),
                    child: Text('Add New Category'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (varietymodel.length > 0)
                ? Container(
                    child: Text(
                      ' Product Varieties',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    width: double.infinity,
                  )
                : SizedBox.shrink(),
            Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: varietymodel.length,
                itemBuilder: (build, index) {
                  return DynamicTextForm(
                    variety: varietymodel[index],
                    delete: () => deletewidget(index),
                    keyform: form,
                  );
                },
                shrinkWrap: true,
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  varietymodel.add(VarietyProductM(
                      productid: _product.id,
                      id: null,
                      varityname: null,
                      price: 0,
                      wsp: 0));
                });
              },
              child: Text('Add New Variety'),
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Save Product'),
        icon: Icon(Icons.save),
        onPressed: () {
          _saveform(context);
        },
      ),
    );
  }
}

// class ImageEditor extends CustomPainter {

//   ImageEditor({
//     this.image
//   });
//   ui.Image image;

//   @override
//   void paint(Canvas canvas, Size size) {
//     ByteData data = image.toByteData();
//     canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }

// }

  // Future pickimage() async {
  //   final pickedFile =
  //       await ImagePicker().getImage(source: ImageSource.gallery);
  //   appDir = await pPath.getExternalStorageDirectory();
  //   imagedir =
  //       await Directory('${appDir.path}/Pictures').create(recursive: true);
  //   // appDirs = await ExtStorage.getExternalStorageDirectory();
  //   // print('<<<<<<<<<<<< $appDirs >>>>>>>>>>');
  //   // imagedir = await Directory('$appDirs/Product E-catalogue/Product Pictures')
  //   // .create(recursive: true);
  //   if (pickedFile != null) {
  //     File croppedFile = await ImageCropper.cropImage(
  //         sourcePath: pickedFile.path,
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.square,
  //           CropAspectRatioPreset.ratio3x2,
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.ratio4x3,
  //           CropAspectRatioPreset.ratio16x9
  //         ],
  //         androidUiSettings: AndroidUiSettings(
  //             toolbarTitle: 'Crop Image',
  //             toolbarColor: Colors.blue,
  //             toolbarWidgetColor: Colors.white,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         iosUiSettings: IOSUiSettings(
  //           minimumAspectRatio: 1.0,
  //         ));
  //     // appDir = await pPath.getExternalStorageDirectory();
  //     fileName = path.basename(croppedFile.path);
  //     savedImage =
  //         await File(croppedFile.path).copy('${imagedir.path}/$fileName');
  //     // _imagefiles.add('${imagedir.path}/$fileName');
  //     _imagefiles.add(savedImage.path);
  //     print(_imagefiles);
  //     _product.updateimageurl(_imagefiles);
  //     snackBar = SnackBar(content: Text('Image Uploaded Succesfully..!'));
  //   } else {
  //     snackBar = SnackBar(content: Text('No Image Selected..!'));
  //   }
  //   setState(() {});
  //   _scaffoldkey.currentState.showSnackBar(snackBar);
  // }