// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mealss/providers/favourites_provider.dart';
// import 'package:mealss/providers/filters_provider.dart';
// import 'package:mealss/screens/categories_screen.dart';
// import 'package:mealss/screens/filters_screen.dart';
// import 'package:mealss/screens/meals_screen.dart';
// import 'package:mealss/widgets/main_drawer.dart';

// const kInitialFilters = {
//   Filter.glutenFree: false,
//   Filter.lactoseFree: false,
//   Filter.vegetarian: false,
//   Filter.vegan: false,
// };

// class TabsScreen extends ConsumerStatefulWidget { //converting stateful widget to consumer stateful widget to use riverpod features
//   const TabsScreen({super.key});

//   @override
//   ConsumerState<TabsScreen> createState() { //converting state to consumer state to use riverpod features
//     return _TabsScreenState();
//   }
// }

// class _TabsScreenState extends ConsumerState<TabsScreen> { //converting state to consumer state to use riverpod features
//   int _selectedPageIndex = 0;
//  // final List<Meal> _favouriteMeals = [];


//   // void _showInfoMessage(String message) {
//   //   ScaffoldMessenger.of(context).clearSnackBars();
//   //   ScaffoldMessenger.of(
//   //     context,
//   //   ).showSnackBar(SnackBar(content: Text(message)));
//   // }

//   // void _toggleMealFavouriteStatus(Meal meal) {
//   //   final isExisting = _favouriteMeals.contains(meal);
//   //   if (isExisting) {
//   //     setState(() {
//   //       _favouriteMeals.remove(meal);
//   //     });
//   //     _showInfoMessage("Meal is no longer a favourite");
//   //   } else {
//   //     setState(() {
//   //       _favouriteMeals.add(meal);
//   //       _showInfoMessage("Marked it as favourite");
//   //     });
//   //   }
//   // }

//   void _selectPage (int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   void _setScreen(String identifier) async {
//     Navigator.of(context).pop();
//     if (identifier == "filters") {
//       await Navigator.of(context).push(
//         //Navigator.push() → returns a
//         //Future<T>(where T is whatever data type you’ll later pass into Navigator.pop(). In this case its
//         // Future<Map<Filter, bool>?>) that will complete only when Navigator.pop() is called.
//         //use of above await is:
//         //You are telling Dart:
//         // “Don’t run the next line until the Future returned by push() completes.”
//         // That means your code pauses at that line,
//         // but the app itself continues running (the UI, the FiltersScreen, etc.).
//         // It’s just your TabsScreen function(_setScreen) that’s waiting for the result.

//         //🧩In short:
//         //Step:	      Code:                      Meaning:
//         // 1	        Navigator.push()	          Opens a new screen and returns a Future
//         // 2	        await	                      Suspends this function(particular async fn. Here its _setScreen) until that Future completes
//         // 3	        Navigator.pop(data)	        Closes that screen and completes the Future with data
//         // 4	        result	                    Receives whatever data was passed to pop()
//         MaterialPageRoute(
//           builder: (context) =>const FiltersScreen(),
//         ),
//       );
  
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final meals=ref.watch(mealsProvider); //ref property is added by river pod and is available inside build method(like widget. for statefulwidget) method because we are extending ConsumerState for our state class
//     // final activeFilters=ref.watch(filtersProvider); //Uses current filters to show only matching meals. Here we use .watch() instead of .read(), because we want to rebuild automatically when filters change. So, whenever FiltersScreen updates the provider and pops back → Riverpod detects that change → TabsScreen rebuilds → and this line gives the updated map.
    
//     final availableMeals = ref.watch(filteredMealsProvider); //now we will get filterdmeals list here using riverpod
//     Widget activePage = CategoriesScreen(
//       availableMeals: availableMeals,
//       //onToggleFavourite: _toggleMealFavouriteStatus,
//     );
//     var activePageTitle = "Categories";

//     if (_selectedPageIndex == 1) {
//       final favouriteMeals = ref.watch(favouriteMealsProvider); //The riverpod package automatically extracts the "state" property value from the notifier class that belongs to the provider. Hence, ref.watch() yields List<Meal> here(instead of the Notifier class).
//       activePage = MealsScreen(
//         meals: favouriteMeals,//_favouriteMeals,
//         //onToggleFavourite: _toggleMealFavouriteStatus,
//       );
//       activePageTitle = "Your Favourites";
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(activePageTitle)),
//       drawer: MainDrawer(onSelectScreen: _setScreen),
//       body: activePage,
//       bottomNavigationBar: BottomNavigationBar(
//         //scaffold widget inbuilt allows us to set up the bottom navigation bar because its that common requirement for mobile apps.
//         onTap: (index) {
//           _selectPage(index);
//         },
//         currentIndex:
//             _selectedPageIndex, //to highlight the current selectedtab by enlarging it
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.set_meal),
//             label: "Categories",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
//         ],
//       ),
//     );
//   }
// }



//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/providers/favourites_provider.dart';
import 'package:mealss/providers/filters_provider.dart';
import 'package:mealss/screens/categories_screen.dart';
import 'package:mealss/screens/filters_screen.dart';
import 'package:mealss/screens/meals_screen.dart';
import 'package:mealss/widgets/main_drawer.dart';

/// ===============================================================
/// 🧭 TABS SCREEN (CONNECTS UI WITH RIVERPOD STATE)
/// ===============================================================
///
/// 🎯 PURPOSE IN THIS PROJECT:
/// - Hosts bottom navigation (Categories / Favourites)
/// - Reads filtered meals from Riverpod
/// - Reads favourite meals from Riverpod
/// - Navigates to FiltersScreen via drawer
///
/// This screen is the "bridge" between:
/// UI (tabs, navigation)  ↔  App State (Riverpod providers)
///
/// ---------------------------------------------------------------
/// 🧠 WHY ConsumerStatefulWidget (NOT ConsumerWidget)?
///
/// This screen has LOCAL UI STATE:
/// - _selectedPageIndex (which tab is selected)
///
/// Local UI state is temporary and screen-specific,
/// so it should be managed with StatefulWidget.
///
/// Riverpod manages APP STATE:
/// - favourites (favouriteMealsProvider)
/// - filters (filtersProvider → filteredMealsProvider)
///
/// 👉 Therefore:
/// - App State → Riverpod
/// - UI State  → StatefulWidget
///
/// ConsumerStatefulWidget =
/// StatefulWidget + access to Riverpod's `ref`
///
/// ---------------------------------------------------------------

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0; // LOCAL UI STATE (tab index)

  /// Switch between bottom tabs
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  /// Handle drawer navigation (Filters screen)
  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // close drawer

    if (identifier == "filters") {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
      // When FiltersScreen pops:
      // filtersProvider updates → filteredMealsProvider recalculates →
      // this screen rebuilds automatically because of ref.watch(...)
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Read derived state from Riverpod:
    /// - This rebuilds TabsScreen whenever filters change
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      /// Read favourites from Riverpod:
      final favouriteMeals = ref.watch(favouriteMealsProvider);

      activePage = MealsScreen(
        meals: favouriteMeals,
      );
      activePageTitle = "Your Favourites";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favourites",
          ),
        ],
      ),
    );
  }
}