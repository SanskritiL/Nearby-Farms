import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:earth_hack/farm.dart';
import 'package:earth_hack/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_hack/utils.dart';
import 'dart:ui' as ui;

void main() => runApp(Location());

class Farm {
  String farmName;
  String farmerName;
  List address;
  String description;
  String rating;
  String thumbnail;

  Farm(
      {this.farmName,
      this.farmerName,
      this.address,
      this.description,
      this.rating,
      this.thumbnail});
}

final List<Farm> farmInfo = [];
final databaseReference = Firestore.instance;

void _fetch() {
  databaseReference
      .collection("allfarms")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((item) => {
          farmInfo.add(new Farm(
              farmName: item.data["farm_name"],
              farmerName: item.data["farmer_name"],
              address: item.data["address"],
              rating: item.data["rating"],
              description: item.data["description"],
              thumbnail: item.data["thumbnail"])),
        });
  });
}

class Location extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Location> {
  List<Marker> allMarkers = [];

  BitmapDescriptor customIcon;

  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/Home.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  void initState() {
    super.initState();
    _fetch();
    setState(() {
      allMarkers.add(Marker(
          markerId: MarkerId('1'),
          draggable: false,
          icon: customIcon,
          infoWindow: InfoWindow(title: 'Home'),
          position: LatLng(27.506553, 83.448217)));
    });

    farmInfo.forEach((farm) => {
          allMarkers.add(Marker(
              markerId: MarkerId(farm.farmName),
              draggable: false,
              infoWindow:
                  InfoWindow(title: farm.farmName, snippet: farm.description),
              onTap: () {
                print("marker tapped");
              },
              position: LatLng(double.parse(farm.address[0]),
                  double.parse(farm.address[1]))))
        });

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  GoogleMapController mapController;

  PageController _pageController;
  final LatLng _center = const LatLng(27.509008, 83.446127);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _farmList(index, context) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 150.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 235.0,
                    width: 305.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 120.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          farmInfo[index].thumbnail),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 10.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      farmInfo[index].farmName,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.chat,
                                          color: primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new Chat()),
                                          );
                                        })
                                  ],
                                ),
                                Text(
                                  farmInfo[index].farmerName,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  farmInfo[index].description,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    "Ratings: " + farmInfo[index].rating,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 50.0,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 14.2),
              markers: Set.from(allMarkers),
              onMapCreated: _onMapCreated,
            ),
          ),
          Positioned(
            bottom: 20.0,
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: farmInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return _farmList(index, context);
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}
