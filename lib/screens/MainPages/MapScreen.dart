import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:halalapp/components/Helpers/resturant.dart';
import 'package:halalapp/screens/MainPages/better_detailsPage.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.resturants});

  final List<Resturant> resturants;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;

  String message = "Getting Location...";

  //LatLng? currentLocation;
  late Future<LocationData?> _locationData;
  Set<Marker> allMarkers = {};

  Future<LocationData?> _determinePosition() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          message = "Not service enabled";
        });
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _permissionGranted = await location.requestPermission();
        setState(() {
          message = "Permission not granted";
        });
        return null;
      }
    }
    var locationData = await location.getLocation();

    return locationData;
  }

  Route _createRoute(Resturant currentRes) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BetterDetailsPage(currentRes: currentRes),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void turnResturantsToMarkers() {
    List<Resturant> res = widget.resturants;
    for (var i = 0; i < res.length; i++) {
      Resturant singleRes = res[i];

      double latDouble = double.parse(singleRes.latitude);
      double longDouble = double.parse(singleRes.longitude);

      //turn [singleRes] into a Marker
      Marker singleMarker = Marker(
        markerId: MarkerId(singleRes.name),
        position: LatLng(latDouble, longDouble),
        infoWindow: InfoWindow(title: singleRes.name),
        onTap: () {
          Navigator.of(context).push(_createRoute(singleRes));
        },
      );

      //put that new marker into  [allMarkers]
      allMarkers.add(singleMarker);
    }
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/icons8-male-user-55.png")
        .then(((icon) {
      setState(() {
        markerIcon1 = icon;
      });
    }));
  }

  @override
  void initState() {
    turnResturantsToMarkers();
    addCustomIcon();
    _locationData = _determinePosition();
    //requestUserPermission();
    //getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _locationData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return OurGoogleMap(
                allMarkers: allMarkers,
                markerIcon1: markerIcon1,
                locationData: snapshot.data!);
          } else {
            return Center(
              child: Center(
                  child: Column(
                children: [
                  Text(message),
                  CircularProgressIndicator(),
                ],
              )),
            );
          }
        },
      ),
    );
  }
}

class OurGoogleMap extends StatelessWidget {
  static const CameraPosition _curPosition = CameraPosition(
    target: LatLng(40.7484, -73.9857),
    zoom: 12,
  );

  const OurGoogleMap({
    Key? key,
    required this.allMarkers,
    required this.markerIcon1,
    required this.locationData,
  }) : super(key: key);

  final Set<Marker> allMarkers;
  final BitmapDescriptor markerIcon1;
  final LocationData locationData;

  @override
  Widget build(BuildContext context) {
    allMarkers.add(
      Marker(
        markerId: MarkerId("user"),
        position: LatLng(locationData.latitude!, locationData.longitude!),
        infoWindow: InfoWindow(title: "Your Location"),
        icon: markerIcon1,
      ),
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 15),
      markers: allMarkers,
    );
  }
}
