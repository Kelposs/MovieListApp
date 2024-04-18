import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/core/constants/api_constants.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/services/service_provider.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  static const routeName = '/movie_details';
  const MovieDetailsScreen({super.key, required this.movie});
  final Movies movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          FutureBuilder(
            future: ref.read(localDBService).isFavorite(widget.movie.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final isFavorite = snapshot.data as bool;
                return IconButton(
                  onPressed: () async {
                    if (isFavorite) {
                      await ref
                          .read(localDBService)
                          .deleteFavorite(widget.movie.id);
                    } else {
                      await ref
                          .read(localDBService)
                          .insertFavorite(widget.movie);
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      '${ApiConstants.moviePosterURL}/${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (widget.movie.releaseDate != null) ...[
              Text(
                'Release Date: ${widget.movie.releaseDate}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
