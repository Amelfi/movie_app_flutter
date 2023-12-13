import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:movie_app_flutter/models/models.dart';
import 'package:movie_app_flutter/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingSlider extends StatelessWidget {
  final int movieId;
  const CastingSlider({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getAllCredits(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
              constraints: const BoxConstraints(maxWidth: 150),
              width: double.infinity,
              height: 180,
              child: const CupertinoActivityIndicator());
        }
        final List<Cast> cast = snapshot.data!;
        return Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          width: double.infinity,
          height: 190,
          child: ListView.builder(
              itemCount: cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) => _CastCard(cast[index]),
        ));
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final  Cast cast;

  const _CastCard( this.cast );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 110,
      height: 100,
      child: Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(cast.fullMoviePath),
              fit: BoxFit.cover,
            )),
        Text(
          cast.name,
          overflow: TextOverflow.ellipsis,
        )
      ]),
    );
  }
}
