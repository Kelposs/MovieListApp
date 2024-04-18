// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieListResponse {
  MovieListResponse({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });
  late final int page;
  late final List<Movies> movies;
  late final int totalPages;
  late final int totalResults;

  MovieListResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    movies = List.from(json['results']).map((e) => Movies.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['results'] = movies.map((e) => e.toJson()).toList();
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }

  MovieListResponse copyWith({
    int? page,
    List<Movies>? movies,
    int? totalPages,
    int? totalResults,
  }) {
    return MovieListResponse(
      page: page ?? this.page,
      movies: movies ?? this.movies,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovieListResponse &&
        other.page == page &&
        other.movies == movies &&
        other.totalPages == totalPages &&
        other.totalResults == totalResults;
  }

  @override
  int get hashCode =>
      page.hashCode ^
      movies.hashCode ^
      totalPages.hashCode ^
      totalResults.hashCode;
}

class Movies {
  Movies({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
  });

  late final int id;
  late final String overview;
  late final String posterPath;
  late final String? releaseDate;
  late final String title;

  Movies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;

    return data;
  }
}
