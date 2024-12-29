import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/movie/movie_repository.dart';
import '../../../data/services/api/model/movie_detail/movie_detail_api_model.dart';
import '../../../data/services/api/model/movies/movie_api_model.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required MovieRepository movieRepository,
  })  : _movieRepository = movieRepository {
    load = Command0(_load)..execute();
  }

  final MovieRepository _movieRepository;
  final _log = Logger('HomeViewModel');
  List<MovieDetailModel> _movies = [];
  //User? _user;

  late Command0 load;
  late Command1<void, int> deleteBooking;

  List<MovieDetailModel> get movies => _movies;

  //User? get user => _user;

  Future<Result> _load() async {
    try {
      final result = await _movieRepository.getPopularMovies();
      switch (result) {
        case Ok<MoviesModel>():
          _movies = result.value.movies;
          _log.fine('Loaded bookings');
        case Error<MoviesModel>():
          _log.warning('Failed to load bookings', result.error);
          return result;
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
