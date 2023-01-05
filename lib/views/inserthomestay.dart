import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:homestay_raya/model/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class InsertHomestay extends StatefulWidget {
  final User user;
  final Position position;
  final List<Placemark> placemarks;
  const InsertHomestay(
      {super.key,
      required this.user,
      required this.position,
      required this.placemarks});

  @override
  State<InsertHomestay> createState() => _InsertHomestayState();
}

class _InsertHomestayState extends State<InsertHomestay> {
  final TextEditingController _hsnameEditingController =
      TextEditingController();
  final TextEditingController _hsaddressEditingController =
      TextEditingController();
  final TextEditingController _hsfacilityEditingController =
      TextEditingController();
  final TextEditingController _hspriceEditingController =
      TextEditingController();
  final TextEditingController _hspaxEditingController = TextEditingController();
  final TextEditingController _hsstateEditingController =
      TextEditingController();
  final TextEditingController _hslocalEditingController =
      TextEditingController();
  final TextEditingController _hslatEditingController = TextEditingController();
  final TextEditingController _hslonEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _lat, _lng;

  @override
  void initState() {
    super.initState();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _hslatEditingController.text = _lat;
    _hslonEditingController.text = _lng;
    _hsstateEditingController.text =
        widget.placemarks[0].administrativeArea.toString();
    _hslocalEditingController.text = widget.placemarks[0].locality.toString();
  }

  File? _image;
  File? _image2;
  File? _image3;
  var pathAsset = "assets/images/camera.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Homestay")),
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            onTap: _selectImage,
            child: Card(
              elevation: 8,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image!) as ImageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                        height: 250,
                        width: 20,
                        color: Colors.transparent,
                      ),
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image2!) as ImageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                        height: 250,
                        width: 20,
                        color: Colors.transparent,
                      ),
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image3!) as ImageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Homestay",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _hsnameEditingController,
                    validator: (val) => val!.isEmpty || (val.length < 5)
                        ? "Homestay Name must be longer than 5"
                        : null,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Homestay Name',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.house_outlined),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _hsaddressEditingController,
                    validator: (val) => val!.isEmpty || (val.length < 10)
                        ? "Address must be longer than 10"
                        : null,
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Address',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.location_pin,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _hsfacilityEditingController,
                    validator: (val) => val!.isEmpty || (val.length < 5)
                        ? "Facilities should be longer than 5"
                        : null,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Facilities',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.local_activity),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _hspaxEditingController,
                          validator: (val) =>
                              val!.isEmpty ? "Please enter a value" : null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Pax',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.people),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                    ),
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _hspriceEditingController,
                          validator: (val) => val!.isEmpty
                              ? "Price value cannot be empty"
                              : null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Price',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.money),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            controller: _hsstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )))),
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          enabled: false,
                          controller: _hslocalEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Current Locality',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.map),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _hslatEditingController,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Latitude',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )))),
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          enabled: false,
                          controller: _hslonEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Current Longitude',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.map),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                    )
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    child: const Text('Add Homestay'),
                    onPressed: () => {
                      _newProductDialog(),
                    },
                  ),
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  void _newProductDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this homestay?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertProduct() {
    String name = _hsnameEditingController.text;
    String address = _hsaddressEditingController.text;
    String pax = _hspaxEditingController.text;
    String facility = _hsfacilityEditingController.text;
    String price = _hspriceEditingController.text;
    String state = widget.placemarks[0].administrativeArea.toString();
    String local = widget.placemarks[0].locality.toString();
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String base64Image2 = base64Encode(_image2!.readAsBytesSync());
    String base64Image3 = base64Encode(_image3!.readAsBytesSync());

    http.post(
        Uri.parse("${Config.server}/homestay_raya/php/insert_homestay.php"),
        body: {
          "Username": widget.user.name,
          "Name": name,
          "Address": address,
          "Pax": pax,
          "Facilities": facility,
          "Price": price,
          "Latitude": _lat,
          "Longitude": _lng,
          "State": state,
          "Locality": local,
          "image": base64Image,
          "image2": base64Image2,
          "image3": base64Image3
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select picture from:",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 64,
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 64,
                    onPressed: _onGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile2 = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile3 = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null && pickedFile2 != null && pickedFile3 != null) {
      _image = File(pickedFile.path);
      _image2 = File(pickedFile2.path);

      _image3 = File(pickedFile3.path);
      cropImage();
    }
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile2 = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    final pickedFile3 = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null && pickedFile2 != null && pickedFile3 != null) {
      _image = File(pickedFile.path);
      _image2 = File(pickedFile2.path);

      _image3 = File(pickedFile3.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    CroppedFile? croppedFile2 = await ImageCropper().cropImage(
      sourcePath: _image2!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    CroppedFile? croppedFile3 = await ImageCropper().cropImage(
      sourcePath: _image3!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      File imageFile2 = File(croppedFile2!.path);
      File imageFile3 = File(croppedFile3!.path);
      _image = imageFile;
      _image2 = imageFile2;
      _image3 = imageFile3;
      setState(() {});
    }
  }
}
