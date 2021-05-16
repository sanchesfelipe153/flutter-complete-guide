import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final String categoryID;
  final String categoryTitle;
  final List<Meal> availableMeals;

  const CategoryMealsScreen({
    required this.categoryID,
    required this.categoryTitle,
    required this.availableMeals,
  });

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final List<Meal> displayedMeals = [];

  @override
  void initState() {
    super.initState();
    displayedMeals.addAll(widget.availableMeals.where((meal) => meal.categories.contains(widget.categoryID)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          final meal = displayedMeals[index];
          return MealItem(
            id: meal.id,
            title: meal.title,
            imageUrl: meal.imageUrl,
            duration: meal.duration,
            complexity: meal.complexity,
            affordability: meal.affordability,
          );
        },
        itemCount: displayedMeals.length,
      ),
    );
  }
}

class CategoryMealsScreenData {
  final String categoryID;
  final String categoryTitle;

  const CategoryMealsScreenData(this.categoryID, this.categoryTitle);
}
