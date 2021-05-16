import 'meal.dart';

class Filters {
  final bool glutenFree;
  final bool lactoseFree;
  final bool vegetarian;
  final bool vegan;

  const Filters({
    this.glutenFree = false,
    this.lactoseFree = false,
    this.vegetarian = false,
    this.vegan = false,
  });

  bool apply(Meal meal) {
    if (glutenFree && !meal.isGlutenFree) return false;
    if (lactoseFree && !meal.isLactoseFree) return false;
    if (vegetarian && !meal.isVegetarian) return false;
    if (vegan && !meal.isVegan) return false;
    return true;
  }
}
