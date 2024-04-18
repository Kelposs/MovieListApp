import 'package:flutter/material.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/views/favorites_list_screen.dart';
import 'package:moviedb/src/views/movie_details_screen.dart';
import 'package:moviedb/src/views/movies_list_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MovieListScreen.routeName: (context) =>  const MovieListScreen(),
  MovieDetailsScreen.routeName: (context) => MovieDetailsScreen(movie: ModalRoute.of(context)?.settings.arguments as Movies),
  FavoritesListScreen.routeName: (context) => const FavoritesListScreen(),
};
