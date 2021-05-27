import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;

class LocationHelper {
  LocationHelper._();

  static String? _apiKey;

  static String get apiKey {
    var apiKey = _apiKey;
    if (apiKey != null) {
      return apiKey;
    }
    apiKey = DotEnv.env['GOOGLE_MAPS_API_KEY']!.trim();
    _apiKey = apiKey;
    return apiKey;
  }

  static String generateLocationPreviewImage(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?'
        'center=$latitude,$longitude'
        '&zoom=16&size=600x300'
        '&maptype=roadmap'
        '&markers=color:green%7Clabel:A%7C$latitude,$longitude'
        '&key=$apiKey';
  }

  static Future<String> getPlaceAddress(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'),
    );
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
