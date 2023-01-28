// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../model/serverconfig.dart';
import '../model/user.dart';
import 'buyerscreen.dart';
import 'login.dart';
import 'ownerpage.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  late double screenHeight, screenWidth, resWidth;
  int _currentIndex = 2;
  File? _image;
  var pathAsset = "assets/images/profile.png";
  var val = 50;
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar:
            AppBar(title: const Text("Profile"), centerTitle: true, actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Log Out"),
              )
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _logOut();
            }
          })
        ]),
        body: Column(children: [
          const SizedBox(height: 10),
          const Text(
            "Profile Picture",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          _image == null
              ? Flexible(
                  flex: 4,
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "${ServerConfig.server}/homestay_raya/assets/images/profiles/${widget.user.userId}.png?v=$val",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported,
                          size: 128,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: screenHeight * 0.25,
                  child: SizedBox(
                      child: GestureDetector(
                    onTap: _selectImage,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Container(
                          height: 250,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image!) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  )),
                ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () => {_updateProfileDialog(4)},
            color: Colors.lightBlueAccent,
            child: const Text(
              "Update Profile Picture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                  ),
                  Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(200)
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          const Icon(Icons.person),
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                        TableRow(children: [
                          const Icon(Icons.email),
                          Text(
                            widget.user.email.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ]),
                  const SizedBox(height: 20),
                  Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                              width: screenWidth,
                              alignment: Alignment.center,
                              color: Colors.lightBlue,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                child: Text("Profile Settings",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                            Expanded(
                                child: ListView(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    shrinkWrap: true,
                                    children: [
                                  MaterialButton(
                                    onPressed: () => {_updateProfileDialog(1)},
                                    color: Colors.lightBlueAccent,
                                    child: const Text(
                                      "Update Name",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Divider(
                                    height: 2,
                                  ),
                                  MaterialButton(
                                    onPressed: () => {_updateProfileDialog(2)},
                                    color: Colors.lightBlueAccent,
                                    child: const Text(
                                      "Update Email",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () => {_updateProfileDialog(3)},
                                    color: Colors.lightBlueAccent,
                                    child: const Text(
                                      "Update Password",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Divider(
                                    height: 2,
                                  ),
                                ])),
                          ],
                        ),
                      )),
                ],
              )),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.house,
                ),
                label: "Owner"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store_mall_directory,
                ),
                label: "Customer"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => OwnerPage(
                      user: widget.user,
                    )));
      }
      if (_currentIndex == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => BuyerPage(
                      user: widget.user,
                    )));
      }

      if (_currentIndex == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => ProfileScreen(
                      user: widget.user,
                    )));
      }
    });
  }

  _updateProfileDialog(int i) {
    switch (i) {
      case 1:
        _updateNameDialog();
        break;
      case 2:
        _updateEmailDialog();
        break;
      case 3:
        _updatePasswordDialog();
        break;

      case 4:
        _updatePictureDialog();
        break;
    }
  }

  void _updateNameDialog() {
    TextEditingController _nameeditingController = TextEditingController();
    _nameeditingController.text = widget.user.name.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Name",
              style: TextStyle(),
            ),
            content: TextField(
                controller: _nameeditingController,
                keyboardType: TextInputType.phone),
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    "Confirm",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    http.post(
                        Uri.parse(
                            "${ServerConfig.server}/homestay_raya/php/update_profile.php"),
                        body: {
                          "username": _nameeditingController.text,
                          "name": widget.user.name
                        }).then((response) {
                      var data = jsonDecode(response.body);
                      if (response.statusCode == 200 &&
                          data['status'] == 'success') {
                        Fluttertoast.showToast(
                            msg: "Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.green,
                            fontSize: 14.0);
                        setState(() {
                          widget.user.name = _nameeditingController.text;
                          _nameeditingController.text =
                              widget.user.name.toString();
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red,
                            fontSize: 14.0);
                      }
                    });
                  }),
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
    TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _updateEmailDialog() {
    TextEditingController _emaileditingController = TextEditingController();
    _emaileditingController.text = widget.user.email.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Email",
              style: TextStyle(),
            ),
            content: TextField(
                controller: _emaileditingController,
                keyboardType: TextInputType.phone),
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    "Confirm",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    http.post(
                        Uri.parse(
                            "${ServerConfig.server}/homestay_raya/php/update_profile.php"),
                        body: {
                          "username": widget.user.name,
                          "oldEmail": widget.user.email,
                          "email": _emaileditingController.text
                        }).then((response) {
                      var data = jsonDecode(response.body);
                      if (response.statusCode == 200 &&
                          data['status'] == 'success') {
                        Fluttertoast.showToast(
                            msg: "Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.green,
                            fontSize: 14.0);
                        setState(() {
                          widget.user.email = _emaileditingController.text;
                          _emaileditingController.text =
                              widget.user.email.toString();
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red,
                            fontSize: 14.0);
                      }
                    });
                  }),
            ]);
      },
    );
  }

  void _updatePasswordDialog() {
    TextEditingController _passwordeditingController = TextEditingController();
    TextEditingController _password2editingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update Password",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: screenHeight / 5,
            child: Column(
              children: [
                TextField(
                    controller: _passwordeditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'New password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.password,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                TextField(
                    controller: _password2editingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Renter password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.password,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                if (_passwordeditingController.text !=
                    _password2editingController.text) {
                  Fluttertoast.showToast(
                      msg: "Passwords are not the same",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                if (_passwordeditingController.text.isEmpty ||
                    _password2editingController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Fill in passwords",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                Navigator.of(context).pop();
                http.post(
                    Uri.parse(
                        "${ServerConfig.server}/homestay_raya/php/update_profile.php"),
                    body: {
                      "username": widget.user.name,
                      "passkey": _passwordeditingController.text
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                  }
                });
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _updatePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Update Profile Picture ?",
              style: TextStyle(),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    "Confirm",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    String base64Image =
                        base64Encode(_image!.readAsBytesSync());
                    http.post(
                        Uri.parse(
                            "${ServerConfig.server}/homestay_raya/php/update_profile.php"),
                        body: {
                          "userId": widget.user.userId,
                          "image": base64Image
                        }).then((response) {
                      var data = jsonDecode(response.body);
                      if (response.statusCode == 200 &&
                          data['status'] == 'success') {
                        Fluttertoast.showToast(
                            msg: "Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.green,
                            fontSize: 14.0);
                        val = random.nextInt(1000);
                        setState(() {
                          DefaultCacheManager manager = DefaultCacheManager();
                          manager.emptyCache();
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red,
                            fontSize: 14.0);
                      }
                    });
                  }),
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  Future<void> _selectfromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _selectFromCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {}
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
                    onPressed: _selectFromCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 64,
                    onPressed: _selectfromGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
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
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  Future<void> _logOut() async {
    user = User(
      name: "na",
      email: "na",
      passkey: "na",
    );
    await Navigator.push(context,
        MaterialPageRoute(builder: (content) => BuyerPage(user: user)));
  }
}
