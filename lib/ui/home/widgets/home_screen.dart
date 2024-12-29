import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/services/api/model/movie_detail/movie_detail_api_model.dart';
import '../../../routing/routes.dart';
import '../../auth/logout/view_models/logout_viewmodel.dart';
import '../../auth/logout/widgets/logout_button.dart';
import '../../core/localization/applocalization.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/dimens.dart';
import '../../core/ui/error_indicator.dart';
import '../view_models/home_viewmodel.dart';

const String bookingButtonKey = 'movie-button';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.running) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (widget.viewModel.load.error) {
              return ErrorIndicator(
                title: AppLocalization.of(context).errorWhileLoadingHome,
                label: AppLocalization.of(context).tryAgain,
                onPressed: widget.viewModel.load.execute,
              );
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Populate",
                            style: GoogleFonts.rubik(
                              textStyle: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          LogoutButton(
                            viewModel: LogoutViewModel(
                              authRepository: context.read(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: widget.viewModel.movies.length,
                    itemBuilder: (_, index) => _Movie(
                      key: ValueKey(widget.viewModel.movies[index].id),
                      movie: widget.viewModel.movies[index],
                      onTap: () => context.push(Routes.movieWithId(
                          widget.viewModel.movies[index].id!)),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Movie extends StatelessWidget {
  const _Movie({
    super.key,
    required this.movie,
    required this.onTap,
  });

  final MovieDetailModel movie;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(movie.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.grey1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimens.paddingHorizontal),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
            vertical: Dimens.paddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                movie.overview,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
