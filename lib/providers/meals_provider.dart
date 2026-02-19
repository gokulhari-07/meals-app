

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mealss/data/dummy_data.dart';

// /*------------RiverPod:-------------------
// So how does this riverpod package work then?
// Well, in your Flutter app,
// with that riverpod package installed,
// you can create a so-called provider,
// which is some kind of object created based on a class
// that is provided by the riverpod package.
// Now, this provider then can provide a
// potentially dynamic value and it can also provide methods
// that may change that value in the end.
// And then in your application, in any of your widgets,
// not just your screen widgets, but any widgets,
// you can set up a consumer that is connected
// to the provider and it will be connected automatically
// by the riverpod package.
// And in that consumer widget, you can then listen to changes
// through that provider value or even trigger those changes
// by calling those methods that might be provided
// by the provider.
// That's how it works.
// And because you have this central provider
// and any widget can set up a consumer,
// you don't need to pass these cross-state management values (like passing fns as we have seen for toggleFavourites and all)
// between those widgets anymore.
// Instead, every widget can directly connect to the provider.
// And that's what we're now going to implement
// First, with a basic example
// and then step by step with more complex examples. */

// final mealsProvider=Provider((ref){ //created an object for the class Provider from the riverpod package.
//  return dummyMeals;
// }); 


// /*
// Where all we should use ConsumerWidget(stateless widget) and ConsumerStatefulWidget(StatefulWidget) while using Riverpod for statemanagement:

// ✅ RULE 1
// Use ConsumerWidget when the widget has NO LOCAL UI STATE

// A ConsumerWidget = just a stateless widget that can read/watch providers.

// Use ConsumerWidget when:

// ✔ You only show data from provider
// ✔ No TextEditingController
// ✔ No animations
// ✔ No form
// ✔ No scroll controller
// ✔ No temporary variables
// ✔ No need for initState or dispose

// Example (perfect for ConsumerWidget)
// class FavouriteList extends ConsumerWidget {
//   @override
//   Widget build(context, ref) {
//     final items = ref.watch(placesProvider);
//     return ListView(
//       children: items.map((p) => Text(p.placeName)).toList(),
//     );
//   }
// }

// ❌ RULE 2
// Use ConsumerStatefulWidget when you ALSO need local widget state

// A ConsumerStatefulWidget = StatefulWidget + access to Riverpod.

// Use ConsumerStatefulWidget when:

// ✔ You need initState()
// ✔ You need dispose()
// ✔ You use TextEditingController
// ✔ You use Forms
// ✔ You use GlobalKey<FormState>()
// ✔ You use animations
// ✔ You store temporary UI values
// ✔ You use ScrollController
// ✔ You use FocusNode

// Example — your NewItem screen

// This MUST be ConsumerStatefulWidget:

// It has a Form

// It has _enteredPlaceName

// It has _formKey

// Runs validation

// Needs to save text field data

// So:

// class NewItem extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<NewItem> createState() => _NewItemState();
// }

// ⭐ KEY POINT
// Riverpod replaces setState for APP STATE, but NOT for UI STATE

// This is where people get confused.

// ❌ Wrong thinking

// “I’m using Riverpod, so I don’t need StatefulWidgets anymore.”

// ✔ Correct thinking

// “I use Riverpod for SHARED APP STATE.
// I still use StatefulWidget for LOCAL UI STATE.”

// 🧠 THE 2 TYPES OF STATE
// 1️⃣ App State (long-living state)

// → Saved in Providers (Riverpod)
// → Shared between screens
// → Survives navigation
// → Examples:

// List of places

// User profile

// Cart items

// Theme

// API results

// Use StateNotifierProvider / Provider / FutureProvider etc.

// 2️⃣ UI State (short-living temporary state)

// → Kept inside StatefulWidget
// → Only for that screen
// → Destroyed when leaving screen
// → Examples:

// TextField input

// Password show/hide toggle

// Animation progress

// PageView index

// Tab index

// Form validation

// Use StatefulWidget / ConsumerStatefulWidget

// */

// /* 
// Comparison of getx with riverpod for using statelss and statefulWidget:

// ✔ With GetX:

// Many screens can be Stateless

// UI updates via Obx, not StatefulWidget

// Only need StatefulWidget for:

// Forms

// TextEditingControllers

// Local temporary values

// Animation controllers

// ✔ With Riverpod:

// StatelessWidget when only watching providers

// But StatefulWidget required more often because Riverpod doesn’t replace local state
// */

// /* Overall comparison of Getx and riverpod:
// 🥇 WINNER for Performance (mobile + web): GETX
// Why?
// ✔ 1. Least rebuilds

// Obx rebuilds only the widget that listens to that variable.
// No extra rebuilds.
// Super granular.

// ✔ 2. Very small overhead

// GetX is extremely lightweight.
// Small code, very few abstractions.

// ✔ 3. Pure reactivity

// No async “watch” overhead.
// No provider containers.
// Direct reactive variables = fastest.

// ✔ 4. Perfect for UI-heavy apps

// Caller tune app
// Chat
// Music browsing
// Shopping UI
// Lists
// Search
// Scrolling
// Animations

// GetX is extremely fast.

// 🥇 WINNER for App Architecture + Maintainability: RIVERPOD

// Riverpod is better when:

// ✔ team is big
// ✔ app is complex
// ✔ app needs clean architecture
// ✔ you need strict compile-time checks
// ✔ you need async support (FutureProvider, StreamProvider)
// ✔ you want organized testable code
// ✔ you want Flutter-standard patterns

// 🥊 GetX vs Riverpod — Direct Comparison
// Feature	GetX	Riverpod	Winner
// ⚡ Speed	Ultra-fast	Fast	GetX
// 🧠 Memory usage	Very low	Low	GetX
// 🔁 Rebuilds	Very few	Controlled	GetX
// 🛠 Code simplicity	Easiest	Medium	GetX
// 🧪 Testing	Harder	Best	Riverpod
// 🏗 Architecture	Weak	Strong	Riverpod
// 😍 Beginner-friendly	Very easy	Moderate	GetX
// 📦 Async helpers	Weak	Best	Riverpod
// 🎯 Predictability	Hard sometimes	Perfect	Riverpod
// 🔄 Dependency Graph	No	Yes	Riverpod
// 🔥 WHICH ONE SHOULD YOU USE? (personalized answer)

// Based on your coding style (from all messages you shared):

// You like simple, minimal code

// You prefer fast development

// Your app is UI-heavy (caller tune previews, lists, music browsing)

// You already use GetX for dialogs

// You want maximum performance on Web

// You want to avoid extra boilerplate

// 👉 GetX is the BEST choice for you.

// This will give you:

// fewer bugs

// fewer rebuilds

// fewer files

// cleaner code

// fastest UI

// no need to use StatefulWidget everywhere

// less complexity

// 💡 BEST COMBO FOR YOU
// GetX + Stateless Widgets + Obx

// → UI updates instantly
// → minimal rebuilds
// → ultimate performance
// → very simple code

// and

// Use StatefulWidget only for forms & controllers
// (just like you already do)

// 🏁 FINAL RECOMMENDATION

// If your priority is:

// ⭐ Performance
// ⭐ Simplicity
// ⭐ Fast development
// ⭐ Clean UI code
// ⭐ Avoiding unnecessary complexity

// Then:

// 👉 GetX > Riverpod

// for your mobile + web app (caller tune + chatbot project).
// */






//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================
//===================REVISION MODE SHORT VERSION==========================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/data/dummy_data.dart';

/// ===============================================================
/// 📦 MEALS PROVIDER (STATIC DATA SOURCE FOR THE APP)
/// ===============================================================
///
/// 🎯 PURPOSE IN THIS PROJECT:
/// This provider exposes the list of all meals (dummyMeals)
/// so that any screen can read the meals without passing data
/// through widget constructors.
///
/// Screens that depend on this:
/// - CategoriesScreen (indirectly via filteredMealsProvider)
/// - Filters logic (filteredMealsProvider depends on this)
///
/// ---------------------------------------------------------------
/// 🧠 WHY Provider (and not StateNotifierProvider)?
/// - dummyMeals is STATIC data (never changes at runtime)
/// - No add/remove/update logic required
/// - Therefore, a simple Provider is enough
///
/// If meals were fetched from API or modified:
/// → We would use FutureProvider / StateNotifierProvider instead.
///
/// ---------------------------------------------------------------
/// 🧾 PROVIDER DEFINITION
final mealsProvider = Provider((ref) {
  return dummyMeals;
});

/// ---------------------------------------------------------------
/// 🧑‍💻 HOW IT IS USED IN THIS PROJECT
///
/// Example (inside another provider):
/// final meals = ref.watch(mealsProvider);
///
/// Example (inside UI widget):
/// final meals = ref.watch(mealsProvider);
///
/// Whenever mealsProvider changes (not in this project),
/// widgets watching it would rebuild automatically.
///
/// ---------------------------------------------------------------
/// 🧠 REVISION SNAPSHOT
///
/// Provider           → static/read-only data
/// StateNotifier      → mutable app state with logic
/// mealsProvider      → source of all meals in the app
///
/// ===============================================================
