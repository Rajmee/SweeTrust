import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'dart:async';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(23.7474519, 90.4416535);
const LatLng DEST_LOCATION = LatLng(24.2493166, 89.9144265);

class MapTrackerPage extends StatefulWidget {
  @override
  _MapTrackerPageState createState() => _MapTrackerPageState();
}

class _MapTrackerPageState extends State<MapTrackerPage> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  // Set<Polyline> _polylines = {};
  Map<PolylineId, Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAc6p9AIToEJNJ1BU_QG9lXxcOFx6wq2CM";
  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  // GoogleMapController _controller;

  // List<LatLng> routeCoords;
  // GoogleMapPolyline googleMapPolyline =
  //     new GoogleMapPolyline(apiKey: "AIzaSyAc6p9AIToEJNJ1BU_QG9lXxcOFx6wq2CM");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();
    // getsomePoints();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/icons/user.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/icons/car.png");
  }

  // getsomePoints() async {
  //   var permission =
  //       await Permission.getPermissionsStatus([PermissionName.Location]);
  //   if (permission[0].permissionStatus == PermissionStatus.notAgain) {
  //     await Permission.requestPermissions([PermissionName.Location]);
  //   } else {
  //     routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
  //         origin: LatLng(23.7474519, 90.4416535),
  //         destination: LatLng(24.2493166, 89.9144265),
  //         mode: RouteMode.driving);
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Google Office Locations'),
  //       backgroundColor: Colors.green[700],
  //     ),
  //     body: GoogleMap(
  //       onMapCreated: _onMapCreated,
  //       polylines: polyline,
  //       mapType: MapType.normal,
  //       initialCameraPosition: CameraPosition(
  //         target: const LatLng(23.7474519, 90.4416535),
  //         zoom: 18.0,
  //       ),
  //       // markers: _markers.values.toSet(),
  //     ),
  //   );
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                // polylines: _polylines,
                polylines: Set<Polyline>.of(_polylines.values),
                mapType: MapType.normal,
                initialCameraPosition: initialLocation,
                onMapCreated: onMapCreated),
          ],
        ),
      ),
    );
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   setState(() {
  //     _controller = controller;

  //     // polyline.add(Polyline(
  //     //     polylineId: PolylineId('route1'),
  //     //     visible: true,
  //     //     points: routeCoords,
  //     //     width: 4,
  //     //     color: Colors.blue,
  //     //     startCap: Cap.roundCap,
  //     //     endCap: Cap.buttCap));
  //   });
  // }
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon));
    });
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
      PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId("poly");

    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3);

    _polylines[id] = polyline;
  }
}
