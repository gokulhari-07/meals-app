import 'package:flutter/material.dart';
import 'package:mealss/models/meal.dart';
import 'package:mealss/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, 
  required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(
          1,
        ); //name[0] is to access the first character of the string ie; first
    //letter. // This is basically to convert the enum value's first to capital letter. If u hover
    //on substring and all, u will get how it works.
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      clipBehavior: Clip
          .hardEdge, //if this is not here, the above shape wont be applied to the card because of stack. Check for more.
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
          // Navigator.push(context, 
          // MaterialPageRoute(builder: (context)=>MealsDetailsScreen(meal:meal)));
        },
        child: Stack(
          //first child in the stack will be placed first in the ui. Following children will be placed on top of those.
          children: [
            Hero( //to animate widget across different screens, typically
              tag:meal.id, //to identify the widget on this screen and on the target screen. It should be a tag 
              //that is unique per widget. And of course, here, I have multiple meals and multiple images. So 
              //therefore, every image should get its own tag when wrapped in Hero.And the ID is unique per meal and therefore, is the perfect tag per image.
              child: FadeInImage(
                //Image gets faded and appear(kind of animation).kTransparentImage variable is available from the package transparent_image
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            //Image.network(meal.imageUrl), //chceck this to see the diff btween normal image and fadeInImage above.
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow
                          .ellipsis, //cut very long text and replaces with dots...
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: "${meal.duration} min",
                        ), //here actually
                        //this is actually another row and this row kept inside a row as u can see. But then
                        //too it wont give error because of unconstraint width(since usually xpanded is needed
                        //to constaint the inifinite width issue and all) because it is actually constriant by
                        //giving left,right property of Positioned
                        const SizedBox(width: 12),
                        MealItemTrait(icon: Icons.work, label: complexityText),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.currency_rupee,
                          label: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
