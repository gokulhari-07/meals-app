import 'package:flutter/material.dart';
import 'package:mealss/data/dummy_data.dart';
import 'package:mealss/models/category.dart';
import 'package:mealss/models/meal.dart';
import 'package:mealss/screens/meals_screen.dart';
import 'package:mealss/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, 
  //required this.onToggleFavourite, 
  required this.availableMeals});

  //final void Function(Meal meal) onToggleFavourite;
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin{ //with keyword allows you to add a so-called Mixin to a class which u can think of another class being merged into this class behind the scenes.and offering certain features to this class therefore. So here for animation thing, we merged SingleTickerProviderStateMixin into this class. If u have multiple animationControllers for the class, u can use TickerProviderStateMixin instead of SingleTickerProviderStateMixin. But here only once controller we created below for this class
  late AnimationController _animationController;  //late tells Dart that this in the end is a variable which will have a value as soon as it's being used the first time, but not yet when the class is created. So, that there simply is a little timing difference between when this property is created technically and when it will have an initial value, and when it will be needed for the first time. With late, you tell Dart that it will be fine. Once this property is used, it will have a value.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController=AnimationController( //initializing _animationController in initState so then it will be ready before build is executed. But as mentioned, not right away when the class is created. But that's fine because of late. So here we have created an object based on AnimationController class. 
      vsync: this,//vsync is responsible for making sure that this animation executes for every frame. So, typically 60 times per second to overall provide a smooth animation.
      //above this connects with merged class SingleTickerProviderStateMixin 
      duration:Duration(milliseconds: 300),//controlling duration of the animation 
      lowerBound: 0, //
      upperBound: 1,
    );
    _animationController.forward(); //this will starts the animation
  }

  @override
 void dispose(){
  _animationController.dispose(); //this will make sure tht animationcontroller is removed from decive memory once this widget here is removed to make sure memory is freed.
  super.dispose();
 }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals=widget.availableMeals.where((meal)=>meal.categories.contains(category.id)).toList();
    //Navigator.pushNamed(context, "/meals",  arguments: {'title': 'Some title', 'meals': []}, );
    //  Navigator.of(context).push(
    //   MaterialPageRoute(builder: (ctx)=>MealsScreen(meals: [], title: "Some title"))
    //  );
    // OR
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          meals: filteredMeals, 
          title:category.title, 
         // onToggleFavourite: onToggleFavourite, 
          ),
      ),
    ); //The top-most screen(in the stack of screens) is the one visible to the
    // user. The other screen widgets(on lower layers) are not or only partially visible. THts y we are pushing
    // the screen which needed to be showed to the user. Also like in a statefulwidget, context is globally
    // available. But in a stateless widget, its not available globally so thats y here we are defining context
    // as argument for the fn.
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child:GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              2, //by default, gridview main axis is from top to bottom and cross axis is from left to right. So here for SliverGridDelegateWithFixedCrossAxisCount, if i set 2 to  crossAxisCount, i get two columns next to each other. So horizontally i have these two columns.
          childAspectRatio: 3 / 2, //size of grid
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: //availableCategories.map((category)=> CategoryGridItem(category: category)).toList() //alternative way instead of for loop
        [
          for (final category in availableCategories)
            CategoryGridItem(category: category, onSelectCategory: (){
              _selectCategory(context, category);
            },),
        ],
      ),
    // builder: (context,child)=>Padding(
    //   padding: EdgeInsets.only(top: 100-_animationController.value*100 ), //here _animationController.value means lowerbound and upperbound of AnimationController. So initially, 
    //   //the _animationController.value will be 0 and hence for top, value will be 100. But after 300 millisecond, 
    //   //value changes to upperbound which will be 1 and hence top becomes 100-1*100=0. And this animation wont 
    //   //occur when we go to filterscreen and come back. Because in that case, categories screen was never removed 
    //   //from the stack of screens. And the animation of course only restarts if the widget is re-added to the 
    //   //screen because we started it in its state and in its state is only executed when the widget is created. 
    //   //When we move to the filters screen, the categories screen is still on the stack and it's not recreated, 
    //   //if we come back to it. But we will get it when we come back from favourite screen. Ansd ths kind of animation is called explicit animation because we r creating the animation, controlling it and all and not any inbuilt ones.
    //   child: child,// this is the child given above ie; GridView and for the wrapped padding only, we have done animation
    //   //And here as mentioned,we're also using the performance optimization of putting the content that actually should only be partof the animation, but which should not be rebuilt, because its values don't change by putting that content  into the separate child here, so that it's included in the animated content, but not rebuilt. Which helps us with improving the application's performance.
    // )
    
    //check above builder and whole xplanations below and come to this builder:
    builder: (context, child) => SlideTransition( //more features like and curve and all by using this but this is also another kind of explicit animation only.
      position: Tween(//position wants an animation over offset values. 
          begin: const Offset(0, 0.3), //x and y axis value range is between 0 and 1. Here no offset for x axis but 30% down in y axis. ie; content is pushed down 30% down.
          end:Offset(0, 0),
        ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInQuad)),
    child:child 
    )
  );
    
  }
}


/*Easy understanding of animation concept :

🧠 Step 1: What normally happens in an animation

When you animate something in Flutter (like using an AnimationController), you’re telling Flutter:

“Hey, rebuild my widget every frame (≈60 times per second) while this value changes.”

That means:
If you put your entire UI (like the whole GridView) inside the animation, Flutter would rebuild everything 60 times a second!
That’s wasteful — expensive widgets (like a GridView full of images or text) don’t need to rebuild constantly; they just need to move a little or have a property animated.

⚙️ Step 2: What AnimatedBuilder does

AnimatedBuilder is like a middleman that listens to the animation’s value.
Its job: rebuild only a small part of the widget tree whenever the animation changes.

It has two parameters that matter here:

animation: → what it listens to

builder: → the part that rebuilds on every tick

child: → the part that does not rebuild

Think of it like this:

AnimatedBuilder(
  animation: controller,
  child: heavyWidget, // stays frozen in memory
  builder: (context, child) {
    // runs every frame
    return Transform or Padding or Opacity(... child ...)
  },
)


So Flutter rebuilds only the builder part — the Padding or Transform that depends on the animation value.
The child (your GridView) is passed through untouched, meaning it’s built once and reused for all animation frames.

That’s the magic: ✅ GridView is built once, animation just moves it around visually.

🧩 Step 3: Why this is performance optimized

Let’s imagine this timeline:

Frame	Animation value	What rebuilds?	Notes
0 ms	0.0	Padding only	top=100
100 ms	0.33	Padding only	top=67
200 ms	0.66	Padding only	top=33
300 ms	1.0	Padding only	top=0

In all 60 frames of that 300ms animation, Flutter reuses the same GridView object.
Only the position (Padding) updates — that’s extremely cheap.

That’s what makes this code “performance-optimized”:
You separate what moves (animation) from what’s drawn (child).

You could even verify this by adding a print() inside CategoryGridItem — it’ll print only once when first built, not during animation.

🧱 Step 4: Why initState() matters

Now, about initState():

initState() runs once — when your State object is first created.
That means your animation controller starts only when the widget enters the screen for the first time.

When you navigate away (like to FilterScreen) but the screen stays on the navigation stack, Flutter doesn’t destroy it — it just hides it.
So when you come back, initState() is not called again, because the same State object is reused.
That’s why your animation doesn’t replay in that case.

But if you navigate to a completely different screen (like FavouritesScreen) and then back, a new CategoriesScreen is created → initState() runs again → animation plays again.

⚡ Step 5: Core idea to remember (your “never-forget” version)

Let’s make a mental formula for you:

🧩 AnimatedBuilder = smart middleman
→ Rebuilds only the builder part every frame
→ Reuses the child part (so it’s not rebuilt each frame)

⚙️ initState() runs only once per State object
→ animation starts there
→ won’t restart unless the widget is destroyed & recreated

🕐 What does “tick” mean?

In animations, a tick means one frame update.

Your phone’s screen typically refreshes 60 times per second (sometimes 120 Hz on newer devices).
That means Flutter tries to update your app’s visuals 60 times every second — that’s 60 ticks per second.

So when we say:

“the builder rebuilds on every tick,”

it means:

every time the animation controller produces a new value (like 0.0 → 0.016 → 0.033 → … → 1.0), Flutter rebuilds only that small builder part of the widget tree.

🧩 Example timeline (for your animation of 300 ms)

If the animation lasts 300 ms, and the screen runs at 60 fps:

Time (ms)	Frame (tick)	_animationController.value	Padding top value
0	tick 1	0.0	100
16	tick 2	0.05	95
32	tick 3	0.1	90
48	tick 4	0.15	85
...	...	...	...
300	tick 19	1.0	0

Each tick = one little update to your animation value → the padding slightly changes → screen looks like it’s moving smoothly.
But again, only the Padding rebuilds, not the GridView.

🔁 So, in one sentence:

A tick is just one animation frame update — the moment when Flutter re-renders the small animated part using the new animation value.

✅ Quick check:
If the animation lasts 1 second and your device runs at 60 fps, roughly how many ticks happen during that animation?
Ans:60
Exactly right ✅👏

Perfect — 1 second → about 60 ticks → one for each frame.

So now you can think of animation like this simple chain:

Each tick → new animation value → AnimatedBuilder rebuilds only the builder → GridView (child) stays reused

That’s the core performance principle in Flutter animations.
You now fully understand why your code is efficient, and what happens behind the scenes at each frame.

Let’s lock this in with a 10-second mini-recap:

🧠 Remember it like this:

“A tick is one frame of animation.
The builder part reacts every tick,
but the child part stays frozen,
so only what changes gets rebuilt.”




🧭 Flutter StatefulWidget Lifecycle Diagram (for your case):
🚀 1. Widget is created
      ↓
   Flutter calls createState()
      ↓
🧠 2. A new _CategoriesScreenState object is created
      ↓
⚙️ 3. initState() is called once
      - Perfect place to set up controllers, streams, animations
      ↓
🎨 4. build() is called
      - Uses everything set up in initState()
      - Can be called many times (on setState, parent rebuilds, etc)
      ↓
💫 5. Animation runs (controller drives updates each tick)
      ↓
🗑️ 6. dispose() is called when widget is permanently removed
      - Clean up controllers to free memory


🧩 Now: What does late really do here?
✅ When you use:
late AnimationController _animationController;


You’re telling Dart:

“Don’t worry — I’ll assign a real value to this variable before it’s ever used.”

So:

When the State object is created, the variable _animationController exists but is not yet initialized.

In initState(), you actually create the controller:

_animationController = AnimationController(vsync: this, duration: ...);


So by the time build() runs, _animationController has a value → ✅ no problem.

🚫 What if you don’t use late?

If you wrote:

AnimationController _animationController;


❌ Dart would show an error:

“Non-nullable instance field '_animationController' must be initialized.”

That’s because Dart’s null-safety rules say:

Every non-nullable variable must be assigned immediately when the object is created.

But in this case, you can’t assign it immediately —
You need the vsync: this, which is only valid after the State object is fully created, inside initState().

So you use late as a promise:

“I’ll initialize it in initState() before using it in build().”

🧠 Quick analogy:
Stage	Without late	With late
Object creation	Dart expects _animationController to already exist	Dart allows you to initialize it later
initState()	❌ You can’t safely assign (it’s too late)	✅ You assign it properly here
Safety	Compile-time error	Safe and intended usage
🔑 Summary you can remember forever:

🧩 late = “I’ll give it a value before first use.”

You need it for things like AnimationController because

they depend on this (State object),

and this doesn’t exist yet when the variable is declared.      
*/


/* short note of above:

💡 ANIMATION + PERFORMANCE NOTES — CategoriesScreen Explained

───────────────────────────────────────────────
🔹 1. Why `late` is used for AnimationController
───────────────────────────────────────────────
- `late AnimationController _animationController;`
  means: “this variable will be assigned *later*, 
  but before it’s ever used.”
- When the State object is created, this variable
  exists but is empty.
- In `initState()`, we initialize it — so by the time
  `build()` runs, it’s ready.
- Without `late`, Dart would complain because
  non-null variables must be initialized immediately.

───────────────────────────────────────────────
🔹 2. What happens in `initState()`
───────────────────────────────────────────────
- `initState()` runs **only once** — when the widget’s
  State is created for the very first time.
- We create the AnimationController here because:
   ✅ It needs a `vsync` (a Ticker) that’s available only 
      after the State is fully set up.
   ✅ It should start before `build()` runs.
- `vsync: this` connects the controller to the 
  screen’s refresh rate (usually 60 fps), avoiding
  wasted animation frames when the screen is offscreen.
- `duration:` defines how long the animation runs.
- `lowerBound` and `upperBound` define its value range.
- `.forward()` starts the animation immediately.
- When the widget is removed permanently, 
  `dispose()` cleans up the controller from memory.

───────────────────────────────────────────────
🔹 3. What actually happens during animation
───────────────────────────────────────────────
- Every screen refresh (≈60 times per second) is a **tick**.
- Each tick, the controller’s value moves from 0 → 1.
- Example for 300ms duration (≈18 ticks):
    0ms → value=0.0
   100ms → value≈0.33
   200ms → value≈0.66
   300ms → value=1.0

───────────────────────────────────────────────
🔹 4. Role of AnimatedBuilder
───────────────────────────────────────────────
- Listens to the controller and rebuilds only when
  its animation value changes.
- Has two parts:
     ➤ `builder:` runs every tick — the animated part.
     ➤ `child:` is built once and reused — stays static.
- In this code:
    GridView = child (heavy widget → not rebuilt)
    Padding  = builder (small change every tick)
- That’s why the animation is smooth and fast — 
  Flutter only adjusts the Padding’s top value each frame.

───────────────────────────────────────────────
🔹 5. Why this is performance optimized
───────────────────────────────────────────────
✅ Heavy widgets like GridView are built once.
✅ Only the lightweight Padding rebuilds 60x/sec.
✅ Less work for the UI thread → smoother animation.

───────────────────────────────────────────────
🔹 6. When animation restarts or not
───────────────────────────────────────────────
- If you go to another screen (FiltersScreen) and back:
     → same State object reused
     → `initState()` not called again
     → animation doesn’t replay.
- If you leave the screen completely (like popping it
  off the stack) and reopen it:
     → new State object created
     → `initState()` runs again
     → animation restarts.

───────────────────────────────────────────────
🧠 Remember:
“A tick is one frame. 
Builder rebuilds each tick.
Child stays frozen.
Late means we promise to assign before use.
initState() = setup zone for one-time initializations.”
───────────────────────────────────────────────

*/