import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/model/homestay.dart';
import 'package:homestay_raya/views/inserthomestay.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ndialog/ndialog.dart';
import '../model/config.dart';
import 'package:http/http.dart' as http;

import 'detailscreen.dart';

class OwnerPage extends StatefulWidget {
  final User user;
  const OwnerPage({super.key, required this.user});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  var _lat, _lng;
  late Position _position;
  List<Homestay> homeStayList = <Homestay>[];
  String titlecenter = "No Homestay Found";
  var placemarks;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  @override
  void initState() {
    super.initState();
    _loadHomestay();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Owner"), actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New Homestay"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotoNewProduct();
              }
            }),
          ]),
          body: homeStayList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your current Homestay (${homeStayList.length} found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(homeStayList.length, (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _showDetails(index);
                              },
                              onLongPress: () {
                                _deleteDialog(index);
                              },
                              child: Column(children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: 100,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${Config.server}/homestay_raya/assets/images/${homeStayList[index].homestayId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            truncateString(
                                                homeStayList[index]
                                                    .name
                                                    .toString(),
                                                15),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(homeStayList[index].price.toString()).toStringAsFixed(2)}"),
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
          // drawer: MainMenuWidget(user: widget.user)),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _gotoNewProduct() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => InsertHomestay(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadHomestay();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadHomestay() {
    http.post(Uri.parse("${Config.server}/homestay_raya/php/load_homestay.php"),
        body: {"Username": widget.user.name}).then((response) {
      if (response.statusCode == 200) {
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['homestay'] != null) {
            //check if  array object is not null
            homeStayList = <Homestay>[]; //complete the array object definition
            extractdata['homestay'].forEach((v) {
              //traverse products array list and add to the list object array productList
              homeStayList.add(Homestay.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Homestay Available"; //if no data returned show title center
            homeStayList.clear();
          }
        } else {
          titlecenter = "No Homestay Available";
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        homeStayList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }

  Future<void> _showDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homeStayList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestay();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(homeStayList[index].name.toString(), 15)}",
            style: const TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteProduct(index);
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

  void _deleteProduct(index) {
    String? x = homeStayList[index].homestayId;
    try {
      http.post(
          Uri.parse("${Config.server}/homestay_raya/php/delete_product.php"),
          body: {
            "HomestayId": homeStayList[index].homestayId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadHomestay();
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
    } catch (e) {
      print(e.toString());
    }
  }
}
