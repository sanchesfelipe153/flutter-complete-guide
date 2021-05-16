import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;

  const TabsScreen(this.favoriteMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late final List<Tab> _tabs;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const Tab(
        title: 'All Categories',
        label: 'Categories',
        icon: Icons.category,
        screen: CategoriesScreen(),
      ),
      Tab(
        title: 'Your Favorites',
        label: 'Favorites',
        icon: Icons.star,
        screen: FavoritesScreen(widget.favoriteMeals),
      ),
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = _tabs[_selectedTabIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTab.title),
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedTabIndex,
        items: _tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
      ),
      body: _tabs[_selectedTabIndex].screen,
    );
  }
}

class Tab {
  final String title;
  final String label;
  final IconData icon;
  final Widget screen;

  const Tab({required this.title, required this.label, required this.icon, required this.screen});
}
