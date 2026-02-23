// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mealss/models/meal.dart';

// //--1-- And the idea here is to build a provider
// // that simply stores all these favorite meals
// // in a list of favorite meals.

// class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
//   //--3--List<Meal>(or data inside <> of StateNotifier) tells which kind of data is managed by this StateNotifier
//   // and therefore ultimately by the StateNotifierProvider below.
  
//   FavouriteMealsNotifier() : super([]); //Here initially, the list of meals is setup as an empty list. Now, the 
//   //initial data is setup by adding a constructor function, which as you learned has the same name as the class. 
//   //We add an initializer list by adding colon after the constructor function parameter list, and then here we 
//   //call super to reach out to the parent class, ie; to the StateNotifier, and to super we pass our initial data. 
//   //Now that data can be of any shape of your choice, it can be a list, it can be a map, it can be another object 
//   //based on another class,it can be a string, but of course it should be of that type that you define between the
//   // angled brackets of StateNotifier above. So here it should be a list of meals.And therefore here I'll pass such
//   // a list, though at the beginning it will just be an empty list. With that we set the initial data that will be
//   // stored in this notifier, and therefore ultimately also soon in this provider.

//   bool toggleMealFavouriteStatus(Meal meal) { //--11-- we need the bool value returned where this fn is called to give scaffoldmessage below tht meal added or removed from favourites.
//     /*--4--In case of StateNotifier, it doesnot allow to edit an existing value in memory(eg: var 
//     users=["Maxmillan"]; users.add("Manu") is not possible), instead u must always create a new one. 
//     Therefore we wont be able to reach out the List<Meal> by using fns like .add or .remove. Instead, we 
//     need to replace it. Now to replace this, there is this globally available state property. And this 
//     property is made available by the StateNotifier class. So this state property holds our data (List<Meal>). So in
//     this case its a list of meals. And, again, calling add or remove on that state would not be allowed.  */
//     final mealIsFavourite = state.contains(
//       meal,
//     ); //--5--checking whether the meal is a part of list of data(List<Meal>) present inside state

//     if (mealIsFavourite) {
//       //--6--if mealIsFavourite, we have to remove it from the list without using the .remove method. For that we are using where method below. Using .where method, we filter a list and we will get a new list.
//       state = state
//           .where((m) => m.id != meal.id)
//           .toList(); //--7--removing the meal selected from the already existing list m or favourite meals by checking the id of the selected meal is equal or not to the already existing list of favourite meals,m. If its not equal, it will be added to the new list. Equal one is removed. Since where method takes only true statement into the new list.
//       return false;
//     } else {
//       state = [
//         ...state,
//         meal,
//       ]; //--8--if not favourite meal, our selected meal is added to the favourite list or state list or List<Meal>.
//       return true;
//     }
//     //--9--And with that, we are updating this state in an immutable way. So without mutating, without editing the existing state in memory.
//   }
// }

// final favouriteMealsProvider = StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
//   /*--10--Now we just need to connect it to this actual provider(StateNotifierProvider) so that we can use this data in our widgets. 
//     Now, to connect this we have to go to StateNotifierProvider here, and to StateNotifierProvider we still pass
//     a function where we still get a ref that does not change compared to the meals provider(present in another file), and in this function
//     here I now still wanna return a value so that also doesn't change, but the value which I do provide here is 
//     now an insance of this notifier. So we use this class name FavoriteMealsNotifier, and instantiate this. And 
//     now this provider returns an instance of our notifier class so that we have this class for editing the state 
//     and for retrieving the state. Now here we should also do one more thing, StateNotifierProvider is a generic 
//     type and it does understand that it returns a FavoriteMealsNotifier, but it does not understand, unfortunately, 
//     which data this FavoriteMealsNotifier will yield in the end. Therefore, here we should add angled brackets 
//     and add two generic type definitions here. The first one is FavoriteMealsNotifier, but the second one then 
//     is the data that will be yielded by the FavoriteMealsNotifier in the end. And here that will be a list of 
//     meals.So we should add this to get better type support in the rest of our application.Well, and with that, 
//     finally,this FavoriteMealsNotifier is set up.This is how we would do it if we would be using riverpod for 
//     this, and now we can use it in our widgets. We can use it to get our list of favorites,but then also to trigger 
//     this method and change our favorites.
// */

//   //--2--here we should not use our basic Provider class because its used in case of
//   //static data that never changes(like dummyMeals). If u have complex data tht should change under certain circumstances, the provider
//   //class is the wrong choice. In that case u should instead use this StateNotifierProvider class which is another provider class
//   //provided by riverpod that is optimized for data tht can change. Now this StateNotifierProvider class works together with another
//   //class just as stateful widgets work together with state objects you could say.And that other class with which the 
//   //StateNotifierProvider works together is the StateNotifier class, which is also provided by riverpod.Now this class is actually not 
//   //instantiated like this though,  instead you use this class to build your own class that extends this class. Now your own class can
//   // technically have any name you want, but the convention is to end the name with notifier, and I'll therefore name my class 
//   //FavoriteMealsNotifier, like this, and extend StateNotifier. 
//   return FavouriteMealsNotifier();
// });






//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/models/meal.dart';

/// ===============================================================
/// ⭐ FAVOURITES PROVIDER (GLOBAL APP STATE FOR FAVOURITE MEALS)
/// ===============================================================
///
/// 🎯 PURPOSE IN THIS PROJECT:
/// This provider stores the list of meals marked as favourites.
/// It replaces the old local `_favouriteMeals` list that was
/// previously managed with setState in TabsScreen.
///
/// Screens that use this:
/// - TabsScreen → to show "Your Favourites" tab
/// - MealItem / MealDetails → to toggle favourite status
///
/// ---------------------------------------------------------------
/// 🧠 WHY StateNotifierProvider?
/// - Favourite meals is mutable APP STATE
/// - Multiple widgets need to read & modify it
/// - Business logic (add/remove/toggle) should live outside UI
///
/// Therefore:
/// StateNotifier = holds & updates state (List<Meal>)
/// StateNotifierProvider = exposes it to the app
///
/// ---------------------------------------------------------------
/// 🧱 STATE NOTIFIER (HOLDS THE LOGIC)
class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]); // initial favourites = empty list as u can see empty square brckets inside super which represents empty list.

  /// Toggles a meal as favourite.
  /// Returns:
  /// - true  → meal was added to favourites
  /// - false → meal was removed from favourites
  ///
  /// TabsScreen / MealDetails uses this return value
  /// to show a SnackBar message.
  bool toggleMealFavouriteStatus(Meal meal) {
    final isFavourite = state.contains(meal);

    if (isFavourite) {
      // Remove meal (immutable update)
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      // Add meal (immutable update)
      state = [...state, meal];
      return true;
    }
  }
}

/// ---------------------------------------------------------------
/// 🧾 PROVIDER DEFINITION
///
/// Exposes:
/// - state   → List<Meal> (favourite meals)
/// - notifier → FavouriteMealsNotifier (to call toggle method)
final favouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
  return FavouriteMealsNotifier();
});

/// ---------------------------------------------------------------
/// 🧑‍💻 HOW IT IS USED IN THIS PROJECT
///
/// Read favourites (UI rebuilds when list changes):
/// final favourites = ref.watch(favouriteMealsProvider);
///
/// Toggle favourite:
/// ref.read(favouriteMealsProvider.notifier)
///    .toggleMealFavouriteStatus(meal);
///
/// ---------------------------------------------------------------
/// 🧠 IMPORTANT RIVERPOD RULE (IMMUTABILITY)
///
/// ❌ Do NOT mutate state like:
/// state.add(meal);
/// state.remove(meal);
///
/// ✅ Always replace state:
/// state = [...state, meal];
/// state = state.where(...).toList();
///
/// This is required so Riverpod can detect changes
/// and rebuild listening widgets correctly.
///
/// ---------------------------------------------------------------
/// 🧠 REVISION SNAPSHOT
///
/// Favourites = APP STATE (shared across screens)
/// Stored in Riverpod, not in TabsScreen
/// UI reads with ref.watch(...)
/// Logic lives in FavouriteMealsNotifier
///
/// ===============================================================
