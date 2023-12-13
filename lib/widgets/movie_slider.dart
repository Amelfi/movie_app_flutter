import 'package:flutter/material.dart';
import 'package:movie_app_flutter/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movie;
  final String? title;
  final Function onNextPage;
  const MovieSlider(
      {super.key, required this.movie, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.title ?? 'Sin Titulo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.movie.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _MoviePoster(widget.movie[index],
                          '${widget.title}-$index-${widget.movie[index].id}'))),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String hero;
  const _MoviePoster(this.movie, this.hero);

  @override
  Widget build(BuildContext context) {
    movie.heroId = hero;
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: 130,
      height: 190,
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'detail', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(movie.fullMoviePath),
                  fit: BoxFit.cover,
                  width: 130,
                  height: 190,
                ),
              ),
            ),
          ),
          Text(movie.title,
              textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
