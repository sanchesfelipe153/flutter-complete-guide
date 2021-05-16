import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;

  const FavoritesScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) {
    if (favoriteMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
    }
    return ListView.builder(
      itemBuilder: (_, index) {
        final meal = favoriteMeals[index];
        return MealItem(
          id: meal.id,
          title: meal.title,
          imageUrl: meal.imageUrl,
          duration: meal.duration,
          complexity: meal.complexity,
          affordability: meal.affordability,
        );
      },
      itemCount: favoriteMeals.length,
    );
  }
}
