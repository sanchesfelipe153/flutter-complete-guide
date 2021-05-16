import 'package:flutter/material.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';

import 'dummy_data.dart';
import 'models/filters.dart';
import 'models/meal.dart';
import 'routes.dart';
import 'screens/category_meals_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _filters = Filters();
  final List<Meal> _availableMeals = DUMMY_MEALS;
  final List<Meal> _favoriteMeals = [];

  void _changeFilters(Filters newFilters) {
    setState(() {
      _filters = newFilters;
      _availableMeals.clear();
      _availableMeals.addAll(DUMMY_MEALS.where((meal) => _filters.apply(meal)));
    });
  }

  void _toggleFavorite(String mealID) {
    final index = _favoriteMeals.indexWhere((meal) => meal.id == mealID);
    setState(() {
      if (index >= 0) {
        _favoriteMeals.removeAt(index);
      } else {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealID));
      }
    });
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      routes: {
        Routes.home.name: (_) => TabsScreen(_favoriteMeals),
        FiltersScreen.routeName: (_) {
          return FiltersScreen(
            initialFilters: _filters,
            saveFilters: _changeFilters,
          );
        },
        CategoryMealsScreen.routeName: (ctx) {
          final CategoryMealsScreenData data = Routes.arguments(ctx);
          return CategoryMealsScreen(
            categoryID: data.categoryID,
            categoryTitle: data.categoryTitle,
            availableMeals: _availableMeals,
          );
        },
        MealDetailScreen.routeName: (ctx) {
          final MealDetailScreenData data = Routes.arguments(ctx);
          return MealDetailScreen(
            id: data.id,
            toggleFavorite: _toggleFavorite,
            isFavorite: _isMealFavorite(data.id),
          );
        }
      },
    );
  }
}
