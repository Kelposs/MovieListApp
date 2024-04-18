import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb/src/services/api_service.dart';
import 'package:moviedb/src/services/local_db_service.dart';

final apiService = Provider((ref) => ApiService());
final localDBService = Provider((ref) => LocalDBService());
