import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/core/utils/response_model.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/repository/repository_provider.dart';
import 'package:moviedb/src/services/service_provider.dart';
import 'package:moviedb/src/viewmodels/favorites_list_view_model.dart';
import 'package:moviedb/src/viewmodels/movie_list_view_model.dart';

final movieListViewModel =
    StateNotifierProvider<MovieListViewModel, Response<MovieListResponse>>(
        (ref) =>
            MovieListViewModel(movieRepository: ref.watch(movieRepository)));

final favoritesListViewModel =
    StateNotifierProvider<FavoritesViewModel, List<Movies>>(
        (ref) => FavoritesViewModel(localDBService: ref.watch(localDBService)));
