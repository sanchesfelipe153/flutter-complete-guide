import 'package:flutter/material.dart';

import './models/place.dart';
import './screens/add_place_screen.dart';
import './screens/map_screen.dart';
import './screens/place_detail_screen.dart';
import './screens/places_list_screen.dart';

class Routes {
  Routes._();

  static Route<T> placesList<T>() => CustomRoute<T>('/places-list', (_) => const PlacesListScreen());

  static Route<T> placeDetail<T>(Place place) => CustomRoute('/place-detail', (context) => PlaceDetailScreen(place));

  static Route<T> googleMap<T>({
    PlaceLocation initialLocation = MapScreen.defaultLocation,
    bool isSelecting = false,
    bool fullScreenDialog = false,
  }) =>
      CustomRoute<T>(
          '/google-map',
          (_) => MapScreen(
                initialLocation: initialLocation,
                isSelecting: isSelecting,
              ),
          fullScreenDialog);

  static Route<T> addPlace<T>() => CustomRoute<T>('/add-place', (_) => const AddPlaceScreen());
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  final String name;

  CustomRoute(this.name, WidgetBuilder builder, [bool fullscreenDialog = false])
      : super(
          builder: builder,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  toString() => name;
}
