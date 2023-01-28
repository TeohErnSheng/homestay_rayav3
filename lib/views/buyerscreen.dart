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
import 'package:homestay_raya/views/ownerpage.dart';
import 'package:homestay_raya/views/profilescreen.dart';
import 'package:ndialog/ndialog.dart';
import '../model/serverconfig.dart';
import 'package:http/http.dart' as http;

import 'detailscreen.dart';
import 'editscreen.dart';
import 'login.dart';

class BuyerPage extends StatefulWidget {
  final User user;
  const BuyerPage({super.key, required this.user});

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  TextEditingController searchController = TextEditingController();
  int _currentIndex = 1;
  String maintitle = "Buyer Page";
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestay("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          appBar: AppBar(
              title: const Text("Homestay"),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _loadSearchDialog();
                    }),
                PopupMenuButton(itemBuilder: (context) {
                  return [
                    if (widget.user.name != "na") ...[
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Log Out"),
                      )
                    ] else if (widget.user.name == "na") ...[
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Login"),
                      ),
                    ]
                  ];
                }, onSelected: (value) {
                  if (value == 0) {
                    _logIn();
                  }
                  if (value == 1) {
                    _logOut();
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
                        "Homestay ($numberofresult found)",
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
                          return TextButton(
                              onPressed: () =>
                                  {_loadHomestay(search, index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        },
                      ),
                    ),
                    if (widget.user.name != "na") ...[
                      BottomNavigationBar(
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
                    ]
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

  void _loadHomestay(String search, int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http
        .get(
      Uri.parse(
          "${ServerConfig.server}/homestay_raya/php/loadallhomestay.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
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

  Future<void> _logOut() async {
    user = User(
      name: "na",
      email: "na",
      passkey: "na",
    );
    await Navigator.push(context,
        MaterialPageRoute(builder: (content) => BuyerPage(user: user)));
  }

  Future<void> _logIn() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
