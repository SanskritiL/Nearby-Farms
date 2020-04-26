import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            print(item.data["farm_name"]),
            farmInfo.add(new Farm(
                farmName: item.data["farm_name"],
                farmerName: item.data["farmer_name"],
                rating: item.data["farmer_name"],
                description: item.data["description"],
                thumbnail: item.data["thumbnail"])),
          });
    });
  }


