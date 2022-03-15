import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/models/meals.dart';
import 'package:meal_app/screen/category_meals_screen.dart';
import 'package:meal_app/screen/categor_screen.dart';
import 'package:meal_app/screen/filter_screen.dart';
import 'package:meal_app/screen/meal_details_screen.dart';
import 'package:meal_app/screen/tabs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] == true && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] == true && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] == true && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] == true && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex =
        _favouriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favouriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favouriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }

  bool _isMealFavourite(String id) {
    return _favouriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(
                headline6: const TextStyle(
                    fontFamily: 'Raleway', fontWeight: FontWeight.w300),
              )
              .apply(
                fontFamily: 'Raleway',
              ),
        ),
      ),
      // home: const CategoryScreen(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(favouriteMeal: _favouriteMeals),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(
              availableMeals: _availableMeals,
            ),
        MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(
            toggleFavourite: _toggleFavourite, isFavourite: _isMealFavourite),
        FilterScreen.routeName: (ctx) => FilterScreen(
              saveFilters: _setFilters,
              currentFilters: _filters,
            ),
      },
      onGenerateRoute: (settings) {
        if (kDebugMode) {
          print(settings.arguments);
        }
        // return MaterialPageRoute(
        //   builder: (ctx) => const CategoryScreen(),
        // );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const CategoryScreen(),
        );
      },
    );
  }
}
