import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halalapp/components/Helpers/resturant.dart';
import 'package:halalapp/screens/MainPages/screen_router.dart';

class EnterApp extends StatefulWidget {
  const EnterApp({super.key});

  @override
  State<EnterApp> createState() => _EnterAppState();
}

class _EnterAppState extends State<EnterApp> {
  late Future<List<Resturant>> resurants;

  Future<List<Resturant>> getRes() async {
    List<Resturant> allRes = [];
    await FirebaseFirestore.instance.collection('resv2').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            Map<String, dynamic> myData = document.data();

            allRes.add(Resturant(
                name: myData['name'],
                address: myData['address'],
                price: myData['price'],
                phoneNumber: myData['phone'],
                image: myData['image'],
                description: myData['description'],
                borough: myData['borough'],
                latitude: myData['latitude'],
                longitude: myData['longitude']));
          }),
        );
    return allRes;
  }

  @override
  void initState() {
    resurants = getRes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: resurants,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ScreenRouter(
            resturants: snapshot.data!,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
