import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealss/models/meal.dart';
import 'package:mealss/providers/favourites_provider.dart';

class MealsDetailsScreen extends ConsumerWidget {
  //replaced StatelessWidget with ConsumerWidget to trigger the Notifier Method to toggle favourite meals
  const MealsDetailsScreen({
    super.key,
    required this.meal,
    //required this.onToggleFavourite,
  });

  final Meal meal;
  //final void Function(Meal meal) onToggleFavourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //In case of StatefulWidget, We did not have to adjust the build
    //method in the tabs.dart file because there we had a state clas and we replaced that with ConsumerState,
    //which made this ref property globally available in this class. In case of statelesswidget conversion,
    //it doesnot have a general ref property like that.Instead, we have to add it here as a parameter to the
    //build method. But with it added here, we can now use it to call methods from our notifier that is exposed
    //through the provider.
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isFavourite = favouriteMeals.contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              // onToggleFavourite(meal);
              final wasAdded = ref
                  .read(favouriteMealsProvider.notifier)
                  .toggleMealFavouriteStatus(meal);
              //so in a function that is passed as a value to onPressed or something similar, you should not use
              // watch but instead read to not set up an ongoing listener because inside of such a function that
              //would be problematic but instead to just read a value once. Now, the value that should be read
              //here.
              //.notifier gives us access to this notifier class we defined(ie; FavouriteMealsNotifier class).
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? "Meal added as a favourite" : "Meal removed.",
                  ),
                ),
              );
            },
            icon: AnimatedSwitcher(
              //widget that allows to animate the transition from one widget to another.ie; here from star icon to star border icon
              //this is implicit animation.ie; inbuilt one by flutter so no need to create,control or start the animation or any configuration
              transitionBuilder: (child, animation) {
                return RotationTransition(turns: Tween(begin:0.8, end:1.0).animate(animation), child: child);
              },
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                key:ValueKey(isFavourite) 
              ),
            ),
            /*AnimatedSwitcher — the real story (simple, step-by-step)
1) When does AnimatedSwitcher trigger?

AnimatedSwitcher triggers only when the identity of its child changes between builds.
Identity means type + key. If either differs from the previous child, AnimatedSwitcher treats it as a new widget and starts a transition.

Examples that trigger:

Icon(Icons.star, key: ValueKey(true)) → Icon(Icons.star_border, key: ValueKey(false)) (key changed)

Text('A', key: ValueKey('A')) → Text('B', key: ValueKey('B')) (key changed)

Container(color: red) → MyCustomWidget() (type changed)

If you don’t give distinct keys and type stays the same, Flutter may consider it the same widget and no animation runs.

2) What is child inside AnimatedSwitcher?

child is simply the widget you want AnimatedSwitcher to show right now.

On each build() you pass a widget as child. AnimatedSwitcher compares the new child to the previous child.

If they differ (by identity), AnimatedSwitcher keeps both in the tree temporarily: the old child and the new child.

So child is not “a slot where multiple children live” — you always pass one widget. AnimatedSwitcher internally holds old + new during the transition.

3) What is animation passed to transitionBuilder?

animation is an Animation<double> that goes 0 → 1 over duration for the incoming widget.

The same transitionBuilder is used for both incoming and outgoing children:

For the incoming child, animation runs forward from 0 → 1.

For the outgoing child, the animation is played in reverse (effectively 1 → 0).

So when you write RotationTransition(turns: Tween(begin: .8, end: 1.0).animate(animation), child: child), Flutter will:

rotate the new child from .8 → 1 (appearing),

rotate the old child from 1 → .8 (disappearing).

That’s why transitionBuilder must be able to sensibly animate both directions.

4) How are old/new children connected/stacked?

AnimatedSwitcher’s default layoutBuilder stacks children on top of each other (like a Stack) and lets them animate independently.

During the switch both widgets are present in the widget tree at once (over the same layout position). One animates out, the other animates in.

If you want a different arrangement (e.g., slide the new widget from side pushing old out), you can override layoutBuilder and position children yourself.

Diagram (timeline):

Before change: [ child A ]
Change detected:
Frame 0: [ child A (outgoing) , child B (incoming with animation=0) ]
Frame half: [ child A (animating out) , child B (animating in) ]
Frame end: [ child B ]   // A removed after animation ends

5) What if the child changes again while an animation is running?

AnimatedSwitcher can handle that. The currently incoming widget becomes outgoing, and the new widget becomes incoming.

Each widget must have a unique key (or unique identity) for AnimatedSwitcher to track them correctly.

If you don’t use keys, Flutter may reuse widgets and AnimatedSwitcher will not animate as you expect.

So keys are crucial when child content toggles frequently.

7) How transitionBuilder is called (clarifying your observation that “child appears other places”)

You might see child in many places because:

You pass a child to AnimatedSwitcher itself (the widget to display).

AnimatedSwitcher internally calls your transitionBuilder(child, animation) for every child it needs to animate (old and new).

The child parameter inside the transitionBuilder is the particular child being animated right now, not the AnimatedSwitcher’s single child slot.

So there are two different “child” concepts:

The child property you pass to AnimatedSwitcher (the current content).

The child parameter given to transitionBuilder for each animating widget (old/new), which you wrap with animation widgets.
 */
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag:meal.id, //here we have to give the exact tag which is meal id because that's important for Flutter to identify the widget on both the start and the target screen.
              child: Image.network(
                meal.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 14),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
