import 'dart:convert';

PeliculaTmdb peliculaTmdbFromJson(String str) => PeliculaTmdb.fromJson(json.decode(str));

class PeliculaTmdb {
    List<int> genreIds;
    int id;
    String overview;
    String? posterPath;
    DateTime releaseDate;
    String title;

    PeliculaTmdb({
        required this.genreIds,
        required this.id,
        required this.overview,
        this.posterPath,
        required this.releaseDate,
        required this.title,
    });

    factory PeliculaTmdb.fromJson(Map<String, dynamic> json) => PeliculaTmdb(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
    );

}

