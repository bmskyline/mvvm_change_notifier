import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/localization/applocalization.dart';
import '../../core/ui/error_indicator.dart';
import '../view_models/movie_viewmodel.dart';
import 'movie_body.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({
    super.key,
    required this.viewModel,
  });

  final MovieViewModel viewModel;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        // Back navigation always goes to home
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )
        ),
        body: ListenableBuilder(
          // Listen to changes in both commands
          listenable: widget.viewModel.loadMovie,
          builder: (context, child) {
            // If either command is running, show progress indicator
            if (widget.viewModel.loadMovie.running) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // If existing movie fails to load, tap to go /home
            if (widget.viewModel.loadMovie.error) {
              return Center(
                child: ErrorIndicator(
                  title: AppLocalization.of(context).errorWhileLoadingBooking,
                  label: AppLocalization.of(context).close,
                  onPressed: () => context.go(Routes.home),
                ),
              );
            }
            return child!;
          },
          child: MovieBody(viewModel: widget.viewModel),
        ),
      ),
    );
  }
}
