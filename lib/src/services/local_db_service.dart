import 'package:moviedb/src/models/movie_list_response.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class LocalDBService {
  Database? db;

  LocalDBService();

  Future openDb() async {
    db = await openDatabase(path.join(await getDatabasesPath(), "favorites.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE favorites(id INTEGER PRIMARY KEY autoincrement, title TEXT, overview TEXT, release_date TEXT, poster_path TEXT)",
      );
    });
    return db;
  }

  Future<List<Movies>> getFavorites() async {
    if (db == null) {
      await openDb();
    }
    return (await db!.query("favorites"))
        .map((e) => Movies.fromJson(e))
        .toList();
  }

  Future<int> insertFavorite(Movies favorite) async {
    if (db == null) {
      await openDb();
    }
    return await db!.insert("favorites", favorite.toJson());
  }

  Future<int> deleteFavorite(int id) async {
    if (db == null) {
      await openDb();
    }
    return await db!.delete("favorites", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    if (db == null) {
      await openDb();
    }
    final favorites =
        await db!.query("favorites", where: "id = ?", whereArgs: [id]);
    return favorites.isNotEmpty;
  }
}
