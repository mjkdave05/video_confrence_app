import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:video_confrence_app/utils/pop_up.dart';

class LocationService {
  Location location = Location();
  bool _locationAccessEnabled = false;

  Future<void> enableLocationAccess(BuildContext context) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        PopupService.showPopup(context, 'Location service is disabled',
            isError: true);
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        PopupService.showPopup(context, 'Location permission denied',
            isError: true);
        return;
      }
    }

    _locationAccessEnabled = true;
    // ignore: use_build_context_synchronously
    PopupService.showPopup(context, 'Location Access Enabled');
  }

  void disableLocationAccess(BuildContext context) {
    // Logic to disable location access
    _locationAccessEnabled = false;
    PopupService.showPopup(context, 'Location Access Disabled');
  }

  bool get locationAccessStatus => _locationAccessEnabled;
}
