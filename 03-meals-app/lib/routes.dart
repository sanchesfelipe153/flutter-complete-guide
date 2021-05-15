import 'package:flutter/material.dart';

import 'screens/category_meals_screen.dart';
import 'screens/meal_detail_screen.dart';

class Routes {
  Routes._();

  static Route categoryMeals(String categoryID, String categoryTitle) {
    return MaterialPageRoute(builder: (ctx) => CategoryMealsScreen(categoryID, categoryTitle));
  }

  static Route mealDetail(String mealID) {
    return MaterialPageRoute(builder: (ctx) => MealDetailScreen(mealID));
  }
}
