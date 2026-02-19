import 'package:flutter/material.dart';
import 'package:mealss/models/meal.dart';
import 'package:mealss/screens/meals_details_screen.dart';
import 'package:mealss/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.meals, this.title, 
  //required this.onToggleFavourite
  });

  final String? title;
  final List<Meal> meals;
  //final void Function(Meal meal) onToggleFavourite;

  void selectMeal(BuildContext context, Meal meal) { //for the context inside the Navigator.of, we defined BuildContext context inside selectMeal fn
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => MealsDetailsScreen(
      meal: meal,
      //onToggleFavourite: onToggleFavourite,
      )));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (meal) => selectMeal(context, meal),
      ),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Uh oh... Nothing here!",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Try selecting a different category!",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      );
    }

    if(title==null){ //by giving such a condition, on tapping favourites, two appbar title wont occur 
    //because in TabsScreen, for MealsScreen we wont set title so in that facourites case, title will 
    //be null and this if statement get exexuted and hence the content only get displayed without the 
    //below appbar title.
      return content; //once returned, any other code thereafter wont be executed.ie; the return statement
      // below wont get executed.
    }

    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: content,
    );
  }
}
