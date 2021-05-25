import 'dart:convert';

import 'package:collection/collection.dart';

mixin JsonRepresentation {
  static const _equality = MapEquality(values: DeepCollectionEquality());
  static const _encoder = JsonEncoder.withIndent('  ');

  Map<String, dynamic> get jsonMap;

  toJson() => jsonMap;

  String toJsonRepresentation() => _encoder.convert(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonRepresentation && runtimeType == other.runtimeType && _equality.equals(jsonMap, other.jsonMap);

  @override
  int get hashCode => _equality.hash(jsonMap);

  @override
  String toString() => '$runtimeType: ${toJsonRepresentation()}';
}
