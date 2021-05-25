import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import './models/models.dart';

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

  static Uri products(AuthCredential credential, {String? id, bool filterByUser = false}) {
    if (id != null) {
      return _uri('/products/$id.json?auth=${credential.token}');
    }
    if (filterByUser) {
      return _uri('/products.json?auth=${credential.token}&orderBy="creatorID"&equalTo="${credential.userID}"');
    }
    return _uri('/products.json?auth=${credential.token}');
  }

  static Uri userFavorites(AuthCredential credential, {String? productID}) {
    if (productID != null) {
      return _uri('/userFavorites/${credential.userID}/$productID.json?auth=${credential.token}');
    }
    return _uri('/userFavorites/${credential.userID}.json?auth=${credential.token}');
  }

  static Uri orders(AuthCredential credential) {
    return _uri('/orders/${credential.userID}.json?auth=${credential.token}');
  }

  static Uri _uri(String path) => Uri.parse('$domain$path');
}
