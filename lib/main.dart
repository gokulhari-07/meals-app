import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 import 'package:google_fonts/google_fonts.dart';
import 'package:mealss/screens/tabs_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(ProviderScope(child: const App())); // to use riverpod package in the entire app, we should wrap MyApp with ProviderScope. If u just wanna use riverpod only in certain part of the project, we can wrap that only and use.
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      // initialRoute: "/", //names routing is not recommended
      // routes:{
      //   "/":(context)=> const CategoriesScreen(),
      //   "/meals":(context)=> MealsScreen(meals: [], title: "Some title"),
      // },
      home: const TabsScreen()//const CategoriesScreen() 
    );
  }
}