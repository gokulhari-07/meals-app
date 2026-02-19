// ==================code after converting local state of filter screen BUTTON to riverpod=========================
// ==========CHECK BELOW COMMENTED ONE BEFORE GOING THROUGH THIS WHILE REVISING==========================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget { //here statefulwidget is not needed. So converting to ConsumerWidget(statelesswidget in case of riverpod)
  const FiltersScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters=ref.watch(filtersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Your Filters")),
      body:  Column(
          children: [
            SwitchListTile(
              value: activeFilters[Filter.glutenFree]!,
              onChanged: (isChecked) {
                ref.read(filtersProvider.notifier).setFilter(Filter.glutenFree, isChecked); //here we are using setFilter method and removed setState to handle the state using riverpod.
              },
              title: Text(
                "Gluten-free",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              subtitle: Text(
                "Only include gluten-free meals",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filter.lactoseFree]!,
              onChanged: (isChecked) {
                ref.read(filtersProvider.notifier).setFilter(Filter.lactoseFree, isChecked);
              },
              title: Text(
                "Lactose-free",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              subtitle: Text(
                "Only include lactose-free meals",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filter.vegetarian]!,
              onChanged: (isChecked) {
                ref.read(filtersProvider.notifier).setFilter(Filter.vegetarian, isChecked);
              },
              title: Text(
                "Vegetarian",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              subtitle: Text(
                "Only include vegetarian meals",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filter.vegan]!,
              onChanged: (isChecked) {
                ref.read(filtersProvider.notifier).setFilter(Filter.vegan, isChecked);
              },
              title: Text(
                "Vegan",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              subtitle: Text(
                "Only include vegan meals",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      
    );
  }
}



//till vdo 192
//=====================code without converting local state of filterscreen button to riverpod====================================

//----------------------Summary of working of filtering meals using provider:-------------------------------

// | Step | Action                                 | What happens                                           |
// | ---- | -------------------------------------- | ------------------------------------------------------ |
// | 1️⃣  | You toggle switches in `FiltersScreen` | Only `_glutenFreeFilterSet` etc. change locally        |
// | 2️⃣  | You press back                         | `onPopInvokedWithResult` runs and calls `setFilters()` |
// | 3️⃣  | Provider state updates                 | `filtersProvider` now holds the new Map                |
// | 4️⃣  | Riverpod notices a change              | Any widget using `ref.watch(filtersProvider)` rebuilds |
// | 5️⃣  | `TabsScreen` rebuilds                  | It filters `meals` using new filter map                |
// | 6️⃣  | UI updates                             | Only matching meals are shown 🎉   

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mealss/providers/filters_provider.dart';

// class FiltersScreen extends ConsumerStatefulWidget {
//   const FiltersScreen({super.key});
  

//   @override
//   ConsumerState<FiltersScreen> createState() {
//     return _FilterScreenState();
//   }
// }

// class _FilterScreenState extends ConsumerState<FiltersScreen> {
//   var _glutenFreeFilterSet = false;
//   var _lactoseFreeFilterSet = false;
//   var _vegetarianFilterSet = false;
//   var _veganFilterSet = false;

  

//   @override
//   void initState(){
//     super.initState();
//     final activeFilters=ref.read(filtersProvider); //here I'm using read instead of watch, because initState is only executed once anyways. So setting
//     // up a listener here doesn't make too much sense, because this code won't run again anyways, unless the widget was removed and re-added.
//     // activeFilters will get the map here.
//     _glutenFreeFilterSet=activeFilters[Filter.glutenFree]!; 
//     _lactoseFreeFilterSet=activeFilters[Filter.lactoseFree]!;
//     _vegetarianFilterSet=activeFilters[Filter.vegetarian]!;
//     _veganFilterSet=activeFilters[Filter.vegan]!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Your Filters")),
//       // drawer: MainDrawer(onSelectScreen: (identifier){
//       //   Navigator.of(context).pop();
//       //   if(identifier=="meals"){
//       //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const TabsScreen()));
//       //   }
//       // }),
//       body: PopScope( 
//         // PopScope is a widget that lets you control what happens when the user tries to navigate back (e.g., pressing the system back button, swipe back, or using the app bar’s back button).
//         canPop: true, //beside explanation is when provider was not used. Now provider is used and we want to automatically pop. So replaced with true.//This means:“Don’t automatically pop this screen when the user tries to go back — let me handle it manually.” bcz we want to pass data to the navigator.push by passing data to the pop as given below.so we are hndlimg the pop manually below.
//         onPopInvokedWithResult: (bool didPop, dynamic result) {  //called when leaving this screen ie; while pressing the back button
//           //didPop → whether Flutter already popped the route automatically.
//           //result → usually null in this case also null because it gets some value only if automatic pop happens or some other pop happens in top of widget tree
//           ref.read(filtersProvider.notifier).setFilters({
//             Filter.glutenFree: _glutenFreeFilterSet,
//             Filter.lactoseFree: _lactoseFreeFilterSet,
//             Filter.vegetarian: _vegetarianFilterSet,
//             Filter.vegan: _veganFilterSet,
//           });
//           //if (didPop) return; //means:if the pop already happened automatically, don’t do anything.”
//         },
//         child: Column(
//           children: [
//             SwitchListTile(
//               value: _glutenFreeFilterSet,
//               onChanged: (isChecked) {
//                 setState(() {
//                   _glutenFreeFilterSet = isChecked;
//                 });
//               },
//               title: Text(
//                 "Gluten-free",
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               subtitle: Text(
//                 "Only include gluten-free meals",
//                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               activeColor: Theme.of(context).colorScheme.tertiary,
//               contentPadding: const EdgeInsets.only(left: 34, right: 22),
//             ),
//             SwitchListTile(
//               value: _lactoseFreeFilterSet,
//               onChanged: (isChecked) {
//                 setState(() {
//                   _lactoseFreeFilterSet = isChecked;
//                 });
//               },
//               title: Text(
//                 "Lactose-free",
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               subtitle: Text(
//                 "Only include lactose-free meals",
//                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               activeColor: Theme.of(context).colorScheme.tertiary,
//               contentPadding: const EdgeInsets.only(left: 34, right: 22),
//             ),
//             SwitchListTile(
//               value: _vegetarianFilterSet,
//               onChanged: (isChecked) {
//                 setState(() {
//                   _vegetarianFilterSet = isChecked;
//                 });
//               },
//               title: Text(
//                 "Vegetarian",
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               subtitle: Text(
//                 "Only include vegetarian meals",
//                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               activeColor: Theme.of(context).colorScheme.tertiary,
//               contentPadding: const EdgeInsets.only(left: 34, right: 22),
//             ),
//             SwitchListTile(
//               value: _veganFilterSet,
//               onChanged: (isChecked) {
//                 setState(() {
//                   _veganFilterSet = isChecked;
//                 });
//               },
//               title: Text(
//                 "Vegan",
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               subtitle: Text(
//                 "Only include vegan meals",
//                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.onBackground,
//                 ),
//               ),
//               activeColor: Theme.of(context).colorScheme.tertiary,
//               contentPadding: const EdgeInsets.only(left: 34, right: 22),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
