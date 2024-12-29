import '../../../utils/result.dart';
import '../../services/api/api_client.dart';
import '../../services/api/model/movie_detail/movie_detail_api_model.dart';
import '../../services/api/model/movies/movie_api_model.dart';
import 'movie_repository.dart';

class MovieRepositoryRemote implements MovieRepository {
  MovieRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final Map<String, MoviesModel> _cachedData = {};

  @override
  Future<Result<MoviesModel>> getPopularMovies() async {
    if (!_cachedData.containsKey("cache")) {
      // No cached data, request activities
      final result = await _apiClient.getMovies();
      if (result is Ok<MoviesModel>) {
        _cachedData["cache"] = result.value;
      }
      return result;
    } else {
      // Return cached data if available
      return Result.ok(_cachedData["cache"]!);
    }
  }

  @override
  Future<Result<MovieDetailModel>> getMovie(int id) async {
    final result = await _apiClient.getMovie(id);
    return result;
  }


}
