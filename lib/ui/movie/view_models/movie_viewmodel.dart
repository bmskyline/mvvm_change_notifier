import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/movie/movie_repository.dart';
import '../../../data/services/api/model/movie_detail/movie_detail_api_model.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class MovieViewModel extends ChangeNotifier {
  MovieViewModel({
    required MovieRepository movieRepository,
  })  :_movieRepository = movieRepository {
    loadMovie = Command1(_load);
  }
  
  final MovieRepository _movieRepository;
  final _log = Logger('MovieViewModel');
  MovieDetailModel? _movie;

  MovieDetailModel? get movie => _movie;

  /// Loads movie by id
  late final Command1<void, int> loadMovie;

  Future<Result<void>> _load(int id) async {
    final result = await _movieRepository.getMovie(id);
    switch (result) {
      case Ok<MovieDetailModel>():
        _log.fine('Loaded movie $id');
        _movie = result.value;
        notifyListeners();
      case Error<MovieDetailModel>():
        _log.warning('Failed to load movie $id');
    }
    return result;
  }
}
