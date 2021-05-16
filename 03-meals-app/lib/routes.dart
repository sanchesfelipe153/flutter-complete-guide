import 'package:flutter/widgets.dart';

import 'screens/category_meals_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/meal_detail_screen.dart';

extension RoutesExtension on NavigatorState {
  Future<T?> pushNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushNamed(route.name, arguments: route.data);
  }

  Future<T?> pushReplacementNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushReplacementNamed(route.name, arguments: route.data);
  }
}

class Routes {
  Routes._();

  static const home = NamedRouteInfo('/');
  static const filters = NamedRouteInfo(FiltersScreen.routeName);

  static NamedRouteInfo categoryMeals(String categoryID, String categoryTitle) =>
      NamedRouteInfo(CategoryMealsScreen.routeName, data: CategoryMealsScreenData(categoryID, categoryTitle));

  static NamedRouteInfo mealDetail(String mealID) {
    return NamedRouteInfo(MealDetailScreen.routeName, data: MealDetailScreenData(mealID));
  }

  static T arguments<T>(BuildContext context) {
    return ModalRoute.of(context)!.settings.arguments as T;
  }
}

class NamedRouteInfo {
  final String name;
  final Object? data;

  const NamedRouteInfo(this.name, {this.data});
}
