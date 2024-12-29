import 'dart:convert';
import 'dart:io';
import '../../../utils/result.dart';
import 'api_url.dart';
import 'model/movie_detail/movie_detail_api_model.dart';
import 'model/movies/movie_api_model.dart';


/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
  })  : _host = host ?? ApiUrl.baseUrl,
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? (() => HttpClient());

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AuthHeaderProvider? _authHeaderProvider;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Future<void> _authHeader(HttpHeaders headers) async {
    /*final header = _authHeaderProvider?.call();
    if (header != null) {
      headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      headers.add(HttpHeaders.authorizationHeader, 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2JhMmM2OTlmYWViNDVhMjYzYjIzMzhjYzkxMTlkMiIsIm5iZiI6MTQ5ODI2NzM3MC41MzksInN1YiI6IjU5NGRiZWU2OTI1MTQxMzExMTAyZDNkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FLzVpNzwWtjgBvVkynTfX0gPle2wJHrsF_Y9hoePM_Q');
    }*/
    headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    headers.add(HttpHeaders.authorizationHeader, 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2JhMmM2OTlmYWViNDVhMjYzYjIzMzhjYzkxMTlkMiIsIm5iZiI6MTQ5ODI2NzM3MC41MzksInN1YiI6IjU5NGRiZWU2OTI1MTQxMzExMTAyZDNkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FLzVpNzwWtjgBvVkynTfX0gPle2wJHrsF_Y9hoePM_Q');
  }

  Future<Result<MoviesModel>> getMovies() async {
    final client = _clientFactory();
    try {
      final request = await client.getUrl(Uri.parse('${_host}popular'));
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        //final json = jsonDecode(stringData) as List<dynamic>;
        final bookings = MoviesModel.fromJson(jsonDecode(stringData));
            //json.map((element) => MoviesModel.fromJson(element));
        return Result.ok(bookings);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<MovieDetailModel>> getMovie(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.getUrl(Uri.parse('$_host/$id'));
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final booking = MovieDetailModel.fromJson(jsonDecode(stringData));
        return Result.ok(booking);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

}
