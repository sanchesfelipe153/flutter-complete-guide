import 'package:flutter/material.dart';

import '../models/filters.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Filters initialFilters;
  final void Function(Filters) saveFilters;

  const FiltersScreen({
    required this.initialFilters,
    required this.saveFilters,
  });

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _lactoseFree = false;
  var _vegetarian = false;
  var _vegan = false;

  @override
  void initState() {
    super.initState();
    _glutenFree = widget.initialFilters.glutenFree;
    _lactoseFree = widget.initialFilters.lactoseFree;
    _vegetarian = widget.initialFilters.vegetarian;
    _vegan = widget.initialFilters.vegan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => widget.saveFilters(Filters(
              glutenFree: _glutenFree,
              lactoseFree: _lactoseFree,
              vegetarian: _vegetarian,
              vegan: _vegan,
            )),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CustomSwitchListTile(
                  title: 'Gluten-free',
                  subtitle: 'Only include gluten-free meals.',
                  currentValue: _glutenFree,
                  updateValue: (newValue) => setState(() => _glutenFree = newValue),
                ),
                CustomSwitchListTile(
                  title: 'Lactose-free',
                  subtitle: 'Only include lactose-free meals.',
                  currentValue: _lactoseFree,
                  updateValue: (newValue) => setState(() => _lactoseFree = newValue),
                ),
                CustomSwitchListTile(
                  title: 'Vegetarian',
                  subtitle: 'Only include vegetarian meals.',
                  currentValue: _vegetarian,
                  updateValue: (newValue) => setState(() => _vegetarian = newValue),
                ),
                CustomSwitchListTile(
                  title: 'Vegan',
                  subtitle: 'Only include vegan meals.',
                  currentValue: _vegan,
                  updateValue: (newValue) => setState(() => _vegan = newValue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool currentValue;
  final void Function(bool) updateValue;

  const CustomSwitchListTile({
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: updateValue,
    );
  }
}
