import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Firebase {
  const Firebase._();

  static String? _domain;
  static String? _apiKey;

  static String get domain {
    var domain = _domain;
    if (domain != null) {
      return domain;
    }
    domain = DotEnv.env['FIREBASE_URL']!.trim();
    _domain = domain;
    return domain;
  }

  static String get apiKey {
    var apiKey = _apiKey;
    if (apiKey != null) {
      return apiKey;
    }
    apiKey = DotEnv.env['FIREBASE_API_KEY']!.trim();
    _apiKey = apiKey;
    return apiKey;
  }

  static Uri products(String authToken, {String? id, String? userID}) {
    if (id != null) {
      return _uri('/products/$id.json?auth=$authToken');
    }
    if (userID != null) {
      return _uri('/products.json?auth=$authToken&orderBy="creatorID"&equalTo="$userID"');
    }
    return _uri('/products.json?auth=$authToken');
  }

  static Uri userFavorites(String authToken, String userID, [String? productID]) {
    if (productID != null) {
      return _uri('/userFavorites/$userID/$productID.json?auth=$authToken');
    }
    return _uri('/userFavorites/$userID.json?auth=$authToken');
  }

  static Uri orders(String authToken, String userID) {
    return _uri('/orders/$userID.json?auth=$authToken');
  }

  static Uri _uri(String path) => Uri.parse('$domain$path');
}
