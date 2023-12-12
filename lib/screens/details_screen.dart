import 'package:flutter/material.dart';
import 'package:movie_app_flutter/models/movie.dart';
import 'package:movie_app_flutter/theme/custom_theme.dart';
import 'package:movie_app_flutter/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //* CustomScrollView sirve para hacer una appbar con slivers
          _CustomAppBar(movie: movie),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: movie),
            _Overview(movie: movie),
            CastingSlider(movieId: movie.id,)
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: CustomTheme.primary,
      pinned: true,
      floating: false,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
              width: double.infinity,
              color: Colors.black12,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )),
          background: FadeInImage(
            placeholder: const AssetImage('assets/images/loading.gif'),
            image: NetworkImage(movie.fullBackImagePath),
            fit: BoxFit.cover,
          )),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {

    // final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      // margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(movie.fullMoviePath),
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              width: 120,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width -190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(movie.originalTitle,
                    style: Theme.of(context).textTheme.titleSmall),
                Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.star_border,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star_border,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star_border,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star_border,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('${movie.voteAverage}',
                          style: Theme.of(context).textTheme.bodySmall)
                    ])
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Text(
          movie.overview,
          textAlign: TextAlign.justify,
        )
      ]),
    );
  }
}
