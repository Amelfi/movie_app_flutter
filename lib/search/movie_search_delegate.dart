import 'package:flutter/material.dart';
import 'package:movie_app_flutter/models/movie.dart';
import 'package:movie_app_flutter/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar Pelicula';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final movieSearch = moviesProvider.searchMovieByName(query);
    // final movieSearch = moviesProvider.searchMovie;

    if (query.isEmpty) {
      return const _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);
    return StreamBuilder(
        stream: moviesProvider.suggestionStream,
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) return const _EmptyContainer();
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              return MovieList(movies[index]);
            },
          );
        });
  }
}

class _EmptyContainer extends StatelessWidget {
  const _EmptyContainer();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
          Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100),
    );
  }
}

class MovieList extends StatelessWidget {
  final Movie movieSearch;

  const MovieList(this.movieSearch, {super.key});

  @override
  Widget build(BuildContext context) {
    movieSearch.heroId = '${movieSearch.popularity}-${movieSearch.id}';
    return ListTile(
      leading: Hero(
        tag: movieSearch.heroId!,
        child: FadeInImage(
            placeholder: const AssetImage('assets/images/no-image.jpg'),
            image: NetworkImage(movieSearch.fullMoviePath),
            width: 50,
            fit: BoxFit.contain,
            
            ),
      ),
      title: Text(movieSearch.title),
      subtitle: Text(movieSearch.originalTitle),
      onTap: () =>
          Navigator.pushNamed(context, 'detail', arguments: movieSearch),
    );
  }
}
