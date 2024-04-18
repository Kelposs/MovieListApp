import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/core/utils/response_model.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/repository/movie_repository.dart';

class MovieListViewModel extends StateNotifier<Response<MovieListResponse>> {
  final MovieRepository _movieRepository;

  MovieListViewModel({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(Response.loading()) {
    getMoviesList();
  }

  Future<Response<MovieListResponse>> getMoviesList(
      {bool nextPage = false}) async {
    if (!nextPage) {
      state = Response.loading();
      try {
        state = await _movieRepository.getMoviesList(1);
      } catch (e) {
        log(e.toString());
        state = Response.error(e.toString());
      }
    } else {
      final movieListResponse = state.data!;

      final page = movieListResponse.page + 1;

      if (page > movieListResponse.totalPages) return state;
      try {
        final response = await _movieRepository.getMoviesList(page);

        if (response.status == Status.success && response.data != null) {
          final List<Movies> newMovieList =
              List.from(movieListResponse.movies + response.data!.movies);
          final newMovieListResponse = MovieListResponse(
              totalResults: response.data!.totalResults,
              page: response.data!.page,
              totalPages: response.data!.totalPages,
              movies: newMovieList);

          state = Response.completed(newMovieListResponse);
        } else {
          return Response.error(response.message);
        }
      } catch (e) {
        log(e.toString());
        return Response.error(e.toString());
      }
    }
    return state;
  }
}
