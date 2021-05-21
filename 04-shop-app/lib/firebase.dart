import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Firebase {
  const Firebase._();

  static String? _domain;

  static String get domain {
    var domain = _domain;
    if (domain != null) {
      return domain;
    }
    domain = DotEnv.env['FIREBASE_URL']!.trim();
    _domain = domain;
    return domain;
  }

  static Uri products([String? id]) {
    if (id != null) {
      return _uri('/products/$id.json');
    }
    return _uri('/products.json');
  }

  static Uri orders([String? id]) {
    if (id != null) {
      return _uri('/orders/$id.json');
    }
    return _uri('/orders.json');
  }

  static Uri _uri(String path) => Uri.parse('$domain$path');
}
