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
import 'package:homestay_raya/views/login.dart';
import 'package:homestay_raya/views/profilescreen.dart';
import 'package:ndialog/ndialog.dart';
import '../model/serverconfig.dart';
import 'package:http/http.dart' as http;

import 'buyerscreen.dart';
import 'detailscreen.dart';
import 'editscreen.dart';

class OwnerPage extends StatefulWidget {
  final User user;
  const OwnerPage({super.key, required this.user});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  TextEditingController searchController = TextEditingController();
  int _currentIndex = 0;
  String maintitle = "Home Page";
  var _lat, _lng;
  late Position _position;
  List<Homestay> homeStayList = <Homestay>[];
  String titlecenter = "No Homestay Found";
  var placemarks;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  String search = "all";
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;
  late User user;
  @override
  void initState() {
    super.initState();
    _loadHomestay(search, 1);
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
          appBar:
              AppBar(title: const Text("Owner"), centerTitle: true, actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _loadSearchDialog();
                }),
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New Homestay"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Log Out"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotoNewProduct();
              }
              if (value == 1) {
                _gotoBuyer();
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
                        "Your registered Homestay (${homeStayList.length} found)",
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
                                _choiceDialog(index);
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
                                        "${ServerConfig.server}/homestay_raya/assets/images/${homeStayList[index].homestayId}.png",
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "State: ${(homeStayList[index].state)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Locality: ${(homeStayList[index].locality)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Price: RM ${double.parse(homeStayList[index].price.toString()).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return SizedBox(
                            width: 50,
                            child: TextButton(
                                onPressed: () =>
                                    {_loadHomestay(search, index + 1)},
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: color, fontSize: 18),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                  label: "Homestay"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "Profile"),
            ],
          ),
        ));
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
      _loadHomestay(search, 1);
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> _gotoBuyer() async {
    user = User(
      name: "na",
      email: "na",
      passkey: "na",
    );
    await Navigator.push(context,
        MaterialPageRoute(builder: (content) => BuyerPage(user: user)));
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

  void _loadHomestay(String search, int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(
            "${ServerConfig.server}/homestay_raya/php/load_homestay.php?search=$search&pageno=$pageno"),
        body: {"Username": widget.user.name}).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['homestay'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            homeStayList = <Homestay>[];
            extractdata['homestay'].forEach((v) {
              homeStayList.add(Homestay.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Homestay Available";
            homeStayList.clear();
          }
        } else {
          titlecenter = "No Homestay Available";
        }
      } else {
        titlecenter = "No Homestay Available"; //status code other than 200
        homeStayList.clear(); //clear productList array
      }
      setState(() {});
    });
  }

  Future<void> _editDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homeStayList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => EditScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestay(search, 1);
  }

  Future<void> _showDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homeStayList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestay(search, 1);
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

  _choiceDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Pick an option",
            style: TextStyle(),
          ),
          content:
              const Text("Which action do you want to do?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "View",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _showDetails(index);
              },
            ),
            TextButton(
              child: const Text(
                "Edit",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _editDetails(index);
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
          Uri.parse(
              "${ServerConfig.server}/homestay_raya/php/delete_product.php"),
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
          _loadHomestay(search, 1);
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

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadHomestay(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
}
