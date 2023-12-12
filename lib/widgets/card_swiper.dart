import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:movie_app_flutter/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movie;
  const CardSwiper({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (movie.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    // print(movie);

    return Container(
        width: double.infinity,
        height: size.height * 0.5,
        color: Colors.white,
        child: Swiper(
          itemCount: movie.length,

          itemWidth: size.width * 0.6,
          itemHeight: size.height * 0.4,
          layout: SwiperLayout.STACK,

          indicatorLayout: PageIndicatorLayout.COLOR,
          // autoplay: true,
          // pagination: const SwiperPagination(),
          // control: const SwiperControl(),
          itemBuilder: (_, index) {
            // print(movie[index].backdropPath);
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'detail',
                  arguments: movie[index]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(movie[index].fullMoviePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ));
  }
}
