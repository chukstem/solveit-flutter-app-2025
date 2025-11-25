import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng start, LatLng end) {
  const double earthRadius = 6371000; // Radius of the Earth in meters
  double dLat = (end.latitude - start.latitude) * (pi / 180);
  double dLng = (end.longitude - start.longitude) * (pi / 180);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(start.latitude * (pi / 180)) *
          cos(end.latitude * (pi / 180)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  debugPrint((earthRadius * c).toString());
  return earthRadius * c; // Distance in meters
}

extension MapExtensions on GoogleMapController {
  bool isMapControllerInitialized() {
    try {
      // Attempt to access the variable
      toString(); // This will throw an error if not initialized
      return true; // If no error, it's initialized
    } catch (e) {
      return false; // If an error is caught, it's not initialized
    }
  }
}