import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import '../model/homestay.dart';

class DetailsScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  const DetailsScreen({
    Key? key,
    required this.homestay,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var pathAsset = "assets/images/camera.png";
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
  File? _image;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _hsnameEditingController.text = widget.homestay.name.toString();
    _hsaddressEditingController.text = widget.homestay.address.toString();
    _hsfacilityEditingController.text = widget.homestay.facility.toString();
    _hspriceEditingController.text = widget.homestay.price.toString();
    _hspaxEditingController.text = widget.homestay.pax.toString();
    _hsstateEditingController.text = widget.homestay.state.toString();
    _hslocalEditingController.text = widget.homestay.locality.toString();
    _hslatEditingController.text = widget.homestay.latitude.toString();
    _hslonEditingController.text = widget.homestay.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Details/Edit")),
        body: SingleChildScrollView(
          child: Column(children: [
            Card(
              elevation: 8,
              child: Container(
                height: 250,
                width: 200,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          CachedNetworkImage(
                            width: resWidth / 2,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Config.server}/homestay_raya/assets/images/${widget.homestay.homestayId}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Container(
                            height: 250,
                            width: 20,
                            color: Colors.transparent,
                          ),
                          CachedNetworkImage(
                            width: resWidth / 2,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Config.server}/homestay_raya/assets/images/${widget.homestay.homestayId}2.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Container(
                            height: 250,
                            width: 20,
                            color: Colors.transparent,
                          ),
                          CachedNetworkImage(
                            width: resWidth / 2,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Config.server}/homestay_raya/assets/images/${widget.homestay.homestayId}3.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ])),
                  ],
                ),
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
                      "Homestay details",
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
                      child: const Text('Update Homestay'),
                      onPressed: () => {_updateHomestayDialog()},
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ));
  }

  _updateHomestayDialog() {
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
            "Update this homestay?",
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
                _updateProduct();
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

  void _updateProduct() {
    String name = _hsnameEditingController.text;
    String address = _hsaddressEditingController.text;
    String facility = _hsfacilityEditingController.text;
    String price = _hspriceEditingController.text;
    String pax = _hspaxEditingController.text;

    http.post(
        Uri.parse("${Config.server}/homestay_raya/php/update_homestay.php"),
        body: {
          "HomestayId": widget.homestay.homestayId,
          "Username": widget.user.name,
          "Name": name,
          "Address": address,
          "Pax": pax,
          "Facilities": facility,
          "Price": price,
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
}
