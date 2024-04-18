import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:moviedb/src/services/local_db_service.dart';

class FavoritesViewModel extends StateNotifier<List<Movies>>{
  final LocalDBService _localDBService;
  FavoritesViewModel({required LocalDBService localDBService}) : _localDBService = localDBService, super([]){
    getFavorites();
  }

  Future<void> getFavorites() async{
    state = await _localDBService.getFavorites();
  }

  Future<void> addFavorite(Movies movie) async{
    await _localDBService.insertFavorite(movie);
    getFavorites();
  }

  Future<void> removeFavorite(Movies movie) async{
    await _localDBService.deleteFavorite(movie.id);
    getFavorites();
  }

  Future<bool> isFavorite(int id) async{
    return await _localDBService.isFavorite(id);
  }

}