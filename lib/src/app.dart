import 'package:flutter/material.dart';
import 'package:moviedb/src/core/app_routes.dart';
import 'package:moviedb/src/views/movies_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(useMaterial3: true),
      routes: routes,
      initialRoute: MovieListScreen.routeName,
    );
  }
}