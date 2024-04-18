import 'package:moviedb/src/core/constants/api_constants.dart';
import 'package:moviedb/src/core/utils/response_model.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/services/api_service.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository({required ApiService apiService}) : _apiService = apiService;

  Future<Response<MovieListResponse>> getMoviesList(int page) async {
    try {
      final response =
          await _apiService.getRequest(url: ApiConstants.moviesListURL, params: {'page':page});
      return Response.completed(MovieListResponse.fromJson(response.data));
    } catch (e) {
      return Response.error(e.toString());
    }
  }
}
