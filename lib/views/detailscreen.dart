import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/model/user.dart';
import 'package:http/http.dart' as http;
import '../model/serverconfig.dart';
import '../model/homestay.dart';

class DetailScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  const DetailScreen({
    Key? key,
    required this.homestay,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File? _image;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text("View Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                elevation: 8,
                child: Container(
                    height: 250,
                    width: 200,
                    child: Column(children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            CachedNetworkImage(
                              width: resWidth / 2,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig.server}/homestay_raya/assets/images/${widget.homestay.homestayId}.png",
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
                                  "${ServerConfig.server}/homestay_raya/assets/images/${widget.homestay.homestayId}2.png",
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
                                  "${ServerConfig.server}/homestay_raya/assets/images/${widget.homestay.homestayId}3.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ]))
                    ]))),
            const SizedBox(height: 50),
            Center(
              child: Table(
                border: TableBorder.all(),
                defaultColumnWidth: const FixedColumnWidth(190.0),
                children: [
                  TableRow(children: [
                    const Text("Homestay Name",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.name}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Address",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.address}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Pax",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.pax}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Facilities",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.facility}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Price",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(
                        "RM ${double.parse(widget.homestay.price.toString()).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  if (widget.user.name != "na") ...[
                    TableRow(children: [
                      const Text("Contact Number",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      Text(" ${widget.homestay.contactNumber}",
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center)
                    ]),
                  ],
                  TableRow(children: [
                    const Text("Latitude",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.latitude}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Longitude",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.longitude}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("State",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.state}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                  TableRow(children: [
                    const Text("Locality",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Text(" ${widget.homestay.locality}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center)
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
