import 'dart:async';

import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';
import 'package:insta_clone/data_models/location.dart';

class LocationManager {
  Future<Location> getCurrentLocation() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    final placeMarks = await geoCoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placeMark = placeMarks.first;
    return Future.value(convert(
      placeMark,
      position.latitude,
      position.longitude,
    ));
    // Future.valueとは？
    // 値をFutureにするためのコンストラクタ。
  }

  Location convert(
    geoCoding.Placemark placeMark,
    double latitude,
    double longitude,
  ) {
    return Location(
      latitude: latitude,
      longitude: longitude,
      country: placeMark.country ?? "",
      state: placeMark.administrativeArea ?? "",
      city: placeMark.locality ?? "",
    );
  }
}
