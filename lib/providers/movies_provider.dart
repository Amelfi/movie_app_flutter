import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_flutter/helpers/debouncer.dart';
import 'package:movie_app_flutter/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '9e989065492f0fd2f0d6d0843c5e1e41';
  final String _language = 'es-ES';
  final String _baseUrl = 'api.themoviedb.org';
  int _popularPage = 0;
  int _comingMoviesPage = 0;
  // final String _sortBy = 'popularity.desc';
  List<Movie> getOnMovies = [];
  List<Movie> getPopularityMovies = [];
  List<Movie> getCommingNextMovies = [];
  List<Movie> searchMovie = [];
  Map<int, List<Cast>> getCasting = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;
  MoviesProvider() {
    // print('movie providers');
    getOnDisplayMovies();
    getOnDisplayPopularityMovies();
    getOnCommingNext();
    // getAllCredits(movieId);
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    getOnMovies = nowPlayingResponse.results;
    notifyListeners();
    // if (response.statusCode == 200) {}
    // final Map<String, dynamic> decodeData = json.decode(response.body);

    // print(nowPlayingResponse.results[0].title);
  }

  getOnDisplayPopularityMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final moviePopularityResponse = PopularResponse.fromJson(jsonData);
    getPopularityMovies = [
      ...getPopularityMovies,
      ...moviePopularityResponse.results
    ];
    notifyListeners();
  }

  getOnCommingNext() async {
    _comingMoviesPage++;
    final jsonData = await _getJsonData('3/movie/upcoming', _comingMoviesPage);
    final commingNext = NowPlayingResponse.fromJson(jsonData);
    getCommingNextMovies = [...getCommingNextMovies, ...commingNext.results];
    notifyListeners();
  }

  Future<List<Cast>> getAllCredits(int movieId) async {
    if (getCasting.containsKey(movieId)) return getCasting[movieId]!;
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditResponse = CreditsResponse.fromJson(jsonData);
    // print('pidiendo info');
    // getCasting = [...getCasting, ...castings.cast];
    getCasting[movieId] = creditResponse.cast;
    return creditResponse.cast;
  }

  Future<List<Movie>> searchMovieByName(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    final search = SearchMovieResponse.fromJson(response.body);

    return search.results;

    // notifyListeners();
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor $value');
      final results = await searchMovieByName(value);

      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
