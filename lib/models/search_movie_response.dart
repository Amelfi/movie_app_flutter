import 'dart:convert';

import 'package:movie_app_flutter/models/models.dart';

class SearchMovieResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    SearchMovieResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory SearchMovieResponse.fromJson(String str) => SearchMovieResponse.fromMap(json.decode(str));

    // String toJson() => json.encode(toMap());

    factory SearchMovieResponse.fromMap(Map<String, dynamic> json) => SearchMovieResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    // Map<String, dynamic> toMap() => {
    //     "page": page,
    //     "results": List<dynamic>.from(results.map((x) => x.toMap())),
    //     "total_pages": totalPages,
    //     "total_results": totalResults,
    // };
}

