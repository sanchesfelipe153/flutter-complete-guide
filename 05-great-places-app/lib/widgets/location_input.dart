import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../routes.dart';

class LocationInput extends StatefulWidget {
  final void Function(double, double) onSelectPlace;

  const LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _updatePreview(double latitude, double longitude) {
    setState(() => _previewImageUrl = LocationHelper.generateLocationPreviewImage(latitude, longitude));
    widget.onSelectPlace(latitude, longitude);
  }

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();
    _updatePreview(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(Routes.googleMap(
      isSelecting: true,
      fullScreenDialog: true,
    ));
    if (selectedLocation == null) {
      return;
    }
    _updatePreview(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text('No Location Chosen', textAlign: TextAlign.center)
              : Image.network(_previewImageUrl!, fit: BoxFit.cover, width: double.infinity),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
