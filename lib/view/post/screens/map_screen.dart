import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_clone/data_models/location.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final Location location;
  MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _latLng;
  late CameraPosition _cameraPosition;
  GoogleMapController? _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{}; //Setで作る。

  @override
  void initState() {
    _latLng = LatLng(widget.location.latitude, widget.location.longitude);
    _cameraPosition = CameraPosition(target: _latLng, zoom: 15.0,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S
            .of(context)
            .selectPlace),
        actions: <Widget>[
          IconButton(
            onPressed: () => _onPlaceSelected(context),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        onMapCreated: (controller) => onMapCreated(controller),
        onTap: onMapTapped,
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onMapTapped(LatLng latLng) {
    _latLng = latLng;
    _createMarker(_latLng);
  }

  void _createMarker(LatLng latLng) {
    const markerId = MarkerId("selected");
    final marker = Marker(markerId: markerId,position: latLng);
    setState(() {
      _markers[markerId] = marker;
    });
  }

  _onPlaceSelected(BuildContext context) async {
    final postViewModel = context.read<PostViewModel>();
    await postViewModel.updateLocation(_latLng.latitude, _latLng.longitude);
    Navigator.pop(context);
  }
}
