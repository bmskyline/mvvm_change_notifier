import '../../../utils/result.dart';
import '../../services/api/model/movie_detail/movie_detail_api_model.dart';
import '../../services/api/model/movies/movie_api_model.dart';

abstract class MovieRepository {

  Future<Result<MoviesModel>> getPopularMovies();

  Future<Result<MovieDetailModel>> getMovie(int id);
}
