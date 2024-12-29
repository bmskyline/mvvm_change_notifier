import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/services/api/api_url.dart';
import '../../../utils/image_error_listener.dart';
import '../../core/themes/dimens.dart';
import '../view_models/movie_viewmodel.dart';

class MovieBody extends StatelessWidget {
  const MovieBody({
    super.key,
    required this.viewModel,
  });

  final MovieViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final movie = viewModel.movie;
        if (movie == null) return const SizedBox();
        return Padding(
          padding: EdgeInsets.only(
            top: Dimens.paddingVertical,
            left: Dimens.of(context).paddingScreenHorizontal,
            right: Dimens.of(context).paddingScreenHorizontal,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: '${ApiUrl.imageUrl}${movie.posterPath}',
                  height: 200,
                  width: 200,
                  errorListener: imageErrorListener,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      movie.voteCount.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      movie.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
