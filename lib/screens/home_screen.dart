import 'package:flutter/material.dart';
// import 'package:movie_app_flutter/models/models.dart';
import 'package:movie_app_flutter/providers/movies_provider.dart';
import 'package:movie_app_flutter/search/movie_search_delegate.dart';
import 'package:movie_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_swiper_view/flutter_swiper_view.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies'), actions: [
        IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movie: moviesProvider.getOnMovies),

            // SizedBox(height: 5),

            MovieSlider(
                movie: moviesProvider.getPopularityMovies, 
                title: 'Populares', 
                onNextPage: () => moviesProvider.getOnDisplayPopularityMovies()),

            const SizedBox(height: 10),

            MovieSlider(
                movie: moviesProvider.getCommingNextMovies, 
                title: 'Pronto',
                onNextPage: ()=> moviesProvider.getOnCommingNext()),
          ],
        ),
      ),
    );
  }
}
