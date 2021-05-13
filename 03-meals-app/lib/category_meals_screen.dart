import 'package:flutter/material.dart';

import 'dummy_data.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = '/category-meals';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as CategoryMealsData;
    final categoryMeals = DUMMY_MEALS.where((meal) => meal.categories.contains(data.categoryId)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(data.categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return Text(categoryMeals[index].title);
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}

class CategoryMealsData {
  final String categoryId;
  final String categoryTitle;

  const CategoryMealsData(this.categoryId, this.categoryTitle);
}
