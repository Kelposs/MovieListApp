import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/repository/movie_repository.dart';
import 'package:moviedb/src/services/service_provider.dart';

final movieRepository =
    Provider((ref) => MovieRepository(apiService: ref.watch(apiService)));
