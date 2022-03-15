import 'package:flutter/material.dart';
import 'package:meal_app/widget/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> currentFilters;

  const FilterScreen(
      {Key? key, required this.saveFilters, required this.currentFilters})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var _isGlutenFree = false;
  var _isVegetarian = false;
  var _isVegan = false;
  var _isLactoseFree = false;

  @override
  initState() {
    _isGlutenFree = widget.currentFilters['gluten'] == true;
    _isLactoseFree = widget.currentFilters['lactose'] == true;
    _isVegan = widget.currentFilters['vegan'] == true;
    _isVegetarian = widget.currentFilters['vegetarian'] == true;
    super.initState();
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool currentValue, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: updateValue as void Function(bool)?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final selectedFilters = {
                'gluten': _isGlutenFree,
                'lactose': _isLactoseFree,
                'vegan': _isVegan,
                'vegetarian': _isVegetarian,
              };
              widget.saveFilters(selectedFilters);
            },
            icon: const Icon(Icons.save),
          )
        ],
        title: const Text('Your Filters'),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your Meals Selection.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchTile(
                  'Gluten-Free',
                  'Only include gluten-free meals',
                  _isGlutenFree,
                  (newValue) {
                    setState(
                      () {
                        _isGlutenFree = newValue;
                      },
                    );
                  },
                ),
                _buildSwitchTile(
                  'Lactose-Free',
                  'Only include Lactose-Free meals',
                  _isLactoseFree,
                  (newValue) {
                    setState(
                      () {
                        _isLactoseFree = newValue;
                      },
                    );
                  },
                ),
                _buildSwitchTile(
                  'Vegetarian',
                  'Only include Vegetarian meals',
                  _isVegetarian,
                  (newValue) {
                    setState(
                      () {
                        _isVegetarian = newValue;
                      },
                    );
                  },
                ),
                _buildSwitchTile(
                  'Vegan',
                  'Only include Vegan meals',
                  _isVegan,
                  (newValue) {
                    setState(
                      () {
                        _isVegan = newValue;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
