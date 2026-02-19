// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mealss/providers/meals_provider.dart';


// enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

// class FiltersNotifier extends StateNotifier<Map<Filter, bool>>{
//   FiltersNotifier():super({
//     Filter.glutenFree:false,
//     Filter.lactoseFree:false,
//     Filter.vegetarian:false,
//     Filter.vegan:false,
//   }); //So with that here, I have this FilterNotifier. And then as before, for the 
//   //FavoritesNotifier, we must set an initial state by adding the constructor function and then the initializer
//   //list, where we call super and where we then pass our initial state to the parent class.
//   //Now for the favourites provider(see favourites_provider.dart file), the initial state was an empty list. For the filtersProvider, 
//   //it should be a map of filters where every filter is set to false initially.

//   //So that's now my initial filter state here. And with that state defined, we can then add a method that allows 
//   //us to manipulate that state in an immutable way(ie; without editing the existing variable instead by adding new variable as we discussed as example in favourites provider) as you learned.
//   void setFilter(Filter filter, bool isActive){
//     state={
//       ...state, //added the existing map's key-value pairs(by using spread operator) to this map
//       filter:isActive  //So that will then override the key-value pair with the same filter identifier that 
//       //has been copied and all the other key value pairs will be kept along with this new setting here.And 
//       //with that, we are creating a new map with the old key-value pairs and one new key-value pair that 
//       //overrides the respective old key-value pair for the same filter.
//       //??????CHECK HOW IT OVERRIDES OLD KEYVALUE PAIR:
//       //Solution: Eg: var oldMap = {'a': 1, 'b': 2};
//       //              var newMap = {...oldMap, 'b': 99};
//       //              print(newMap); // {a: 1, b: 99}
//       //➡️ The 'b': 2 from oldMap gets overridden by 'b': 99. 
//       //Same logic applies in your filter case. 
      
//       //🔍 4. Why it’s called “immutable update”
//       //Riverpod expects immutable state updates — i.e., instead of changing the existing map, you create a 
//       //new map object.
//       //Even though the content looks the same except for one value, it’s technically a new Map instance, 
//       //which triggers UI rebuilds properly.

//     };
//   }
//   //actually above setFilter fn is not used in the commented FiltersScreen instead below one is used inorder to assign all 
//   //key-value filtered pairs to the state while pressing back button from the filter screen
//   void setFilters(Map<Filter, bool> chosenFilters){
//     state=chosenFilters;
//   }
// }

// final filtersProvider= StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref)=>FiltersNotifier());

  
// //another provider created:
// final filteredMealsProvider= Provider((ref){
//   final meals=ref.watch(mealsProvider); //this is the same ref which we have used in our widgets. It allows us to read or watch providers. Now here 
//   //whenever the watch value ie; mealsProvider changes, this entire Provider fn gets reexecuted so that here we can 
//   //return the updated data. And any widgets that would be listening to this provider would then also be updated if 
//   //one of the dependencies of that provider would update.
//   final activeFilters=ref.watch(filtersProvider); //this also works like above and actually this watch value will 
//   //change and not above because above one inside mealsProvider, its dummy meals and its static. But here, key 
//   //value pair changes according to the enabling and disabling of filter button by the user and hence dut to change 
//   //in watch value, whenver watch value changes, this entire fn gets re-executed.

//   return meals.where((meal) {
//       //.where() keeps only the elements for which your function returns true.
//       // That’s the exact rule.
//       // So when we say “satisfies the condition,” what we really mean is:
//       // “the element makes the function return true.”
//       if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
//         //if in selectedfilters, gluten free is enabled and the meal is not glutenfree, that meal should not be added to the available meals and returns false and it exists the inner fn and goes to check the next meal. If it returns false inside where, it will be removed from the list, availableMeals.
//         return false;
//       }
//       if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
//         return false;
//       }
//       if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
//         return false;
//       }
//       if (activeFilters[Filter.vegan]! && !meal.isVegan) {
//         return false;
//       }
//       return true; //since we want to keep the meals in the available meals, which r filtered from the above conditions
//     }).toList();
// });


// /*
// Riverpod course summary:

// In this course section, you learned about providers
// with help of the Riverpod package,
// which is just one of the many options you have
// for managing global state,
// or cross widget state.
// States that affects multiple widgets.
// And as you learned, packages like this can be very useful
// because in more complex apps
// it's quite common that state changes and state usage,
// don't happen in the same widgets,
// but instead might be far apart from each other.
// And in such cases,
// without such solutions like Riverpod,
// you would have to pass functions around in your app
// so that they can be triggered from different areas
// in the app, than the state is needed.
// With Riverpod, you can instead
// set up a Global State Management Provider, so to say,
// which provides a dynamic value and may also provide methods
// for changing that value,
// which then can be consumed
// from anywhere in your application,
// so that you can read and change these values
// from exactly the places where you need
// to read and change them.
// For that, you learned
// that after installing Flutter Riverpod,
// you must set it up here in the main.dart file
// by wrapping your app
// or whichever widgets need access to this provider feature
// with provider's scope.
// And then you can start setting up some providers.
// Simple providers like this one here, the meals provider,
// which only returns some pretty static data.
// Or more complex providers
// which also allow you to change data.
// The latter can be done by creating these notifier classes,
// based on state notifier,
// combined with the state notifier provider class.
// Either way, you have these providers
// which then can be consumed in your widget
// with help of the ref keyword,
// which is available if you extend ConsumerStatefulWidge
// and ConsumerState in case of StatefulWidgets
// or simply consumer widget in case of StatelessWidgets.
// In that case,
// you would not have a globally available ref keyword,
// but instead, this second argument,
// which you must accept in the build method,
// which gives you this ref object.
// And it's then this ref object
// which can be used to set up listeners
// that make sure that the build method
// is re-executed whenever the provider data changes
// and which then give you access to the provider data.
// Or, as you also saw,
// you can also read values one time to then, for example,
// also trigger those methods that may change the state,
// by reaching out to the notifier class that is related
// to such a notifier provider.
// That's how you can work with those providers
// As you learned, you can also set up providers
// that depend on other providers,
// by using this ref object that's automatically passed
// to these functions that you must accept
// when setting up a provider.
// And with that,
// you now have a powerful cross widget state management tool
// which makes sure that you don't have to pass data
// and functions through all your widgets. */


// /*ARTICLE:
// "riverpod" vs "provider" - There are many Alternatives!
// Older versions of this course used the "provider" package instead of "riverpod" for app-wide state management.
// riverpod is a library created by the same developer as the provider library - it's essentially a re-write of the provider package, fixing many of the flaws of that library (also see: https://github.com/rrousselGit/riverpod).
// That's why this course uses riverpod.
// As mentioned in the section, there generally are many other alternative packages you could use instead - for example Redux or Bloc. 
// This page from the official documentation gives you a good overview of available packages - definitely feel free to play around with 
// them and find the package your personally like most. */








//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/providers/meals_provider.dart';

/// ===============================================================
/// 🧪 FILTERS PROVIDER (GLOBAL APP STATE FOR MEAL FILTERS)
/// ===============================================================
///
/// 🎯 PURPOSE IN THIS PROJECT:
/// This file manages:
/// 1. The current active filters selected by the user
/// 2. The derived list of meals after applying those filters
///
/// Screens that depend on this:
/// - FiltersScreen → updates filters
/// - TabsScreen → reads filteredMealsProvider to show meals
/// - CategoriesScreen → shows only filtered meals
///
/// ---------------------------------------------------------------
/// 🧠 WHY StateNotifierProvider FOR FILTERS?
/// - Filters are mutable APP STATE
/// - Multiple screens read/write this state
/// - Business logic should not live inside widgets
///
/// The filter state is stored as:
/// Map<Filter, bool>
/// Example:
/// { glutenFree: true, vegan: false, ... }
///
/// ---------------------------------------------------------------
/// 🏷 FILTER TYPES
enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

/// ---------------------------------------------------------------
/// 🧱 STATE NOTIFIER (HOLDS FILTER STATE + LOGIC)
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  /// Update a single filter (used when toggling a switch)
  void setFilter(Filter filter, bool isActive) {
    // Immutable update: create a NEW map
    state = {
      ...state,
      filter: isActive, // overrides the old value for this key
    };
  }

  /// Replace all filters at once (used when saving from FiltersScreen)
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

/// ---------------------------------------------------------------
/// 🧾 PROVIDER FOR FILTER STATE
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

/// ---------------------------------------------------------------
/// 🧮 DERIVED PROVIDER: FILTERED MEALS
///
/// This provider depends on:
/// - mealsProvider       → all meals
/// - filtersProvider     → active filters
///
/// Whenever filters change:
/// → This provider recomputes
/// → TabsScreen rebuilds automatically
final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});

/// ---------------------------------------------------------------
/// 🧑‍💻 HOW IT IS USED IN THIS PROJECT
///
/// Update filters (FiltersScreen):
/// ref.read(filtersProvider.notifier)
///    .setFilters(selectedFilters);
///
/// Read filtered meals (TabsScreen):
/// final availableMeals = ref.watch(filteredMealsProvider);
///
/// ---------------------------------------------------------------
/// 🧠 IMPORTANT RIVERPOD CONCEPT (DERIVED STATE)
///
/// filteredMealsProvider does NOT store state.
/// It DERIVES data from other providers.
///
/// Whenever mealsProvider or filtersProvider changes:
/// → filteredMealsProvider recomputes automatically.
///
/// This keeps logic centralized and UI simple.
///
/// ---------------------------------------------------------------
/// 🧠 REVISION SNAPSHOT
///
/// Filters = APP STATE (Riverpod)
/// filteredMeals = DERIVED STATE (computed provider)
/// UI never filters meals manually
/// UI only watches filteredMealsProvider
///
/// ===============================================================
