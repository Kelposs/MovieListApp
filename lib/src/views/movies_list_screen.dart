import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/core/constants/api_constants.dart';
import 'package:moviedb/src/core/utils/response_model.dart';
import 'package:moviedb/src/viewmodels/movie_list_view_model.dart';

import 'package:moviedb/src/viewmodels/view_model_provider.dart';
import 'package:moviedb/src/views/favorites_list_screen.dart';
import 'package:moviedb/src/views/movie_details_screen.dart';

class MovieListScreen extends StatefulWidget {
  static const routeName = '/movies-list';
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, FavoritesListScreen.routeName);
              },
              child: const Text('Favorites'))
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final movieListResponse = ref.watch(movieListViewModel);

          if (movieListResponse.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieListResponse.status == Status.error ||
              movieListResponse.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${movieListResponse.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(movieListViewModel.notifier).getMoviesList(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final movieListData = movieListResponse.data!;
            final movies = movieListData.movies;
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                getMoreItems(scrollInfo, ref.read(movieListViewModel.notifier));
                return true;
              },
              child: ListView.builder(
                itemCount: movies.length + 1,
                itemBuilder: (context, index) {
                  if (index < movies.length) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MovieDetailsScreen.routeName,
                          arguments: movie,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${ApiConstants.moviePosterURL}/${movie.posterPath}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.releaseDate ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return movieListData.page < movieListData.totalPages
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  bool isLoadingMoreItems = false;

  void getMoreItems(
      ScrollNotification scrollInfo, MovieListViewModel viewModel) async {
    if (!isLoadingMoreItems &&
        scrollInfo.metrics.pixels >=
            (scrollInfo.metrics.maxScrollExtent - 56)) {
      isLoadingMoreItems = true;
      await viewModel.getMoviesList(nextPage: true);
      isLoadingMoreItems = false;
    }
  }
}
