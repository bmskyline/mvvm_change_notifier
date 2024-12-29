import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../services/api/api_client.dart';
import '../../services/api/auth_api_client.dart';
import '../../services/api/model/login_request/login_request.dart';
import '../../services/shared_preferences_service.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final AuthApiClient _authApiClient;
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fech Token from SharedPreferences',
          result.error,
        );
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiClient.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );
      if (result) {
        _log.info('User logged int');
        // Set auth status
        _isAuthenticated = true;
        _authToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2JhMmM2OTlmYWViNDVhMjYzYjIzMzhjYzkxMTlkMiIsIm5iZiI6MTQ5ODI2NzM3MC41MzksInN1YiI6IjU5NGRiZWU2OTI1MTQxMzExMTAyZDNkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FLzVpNzwWtjgBvVkynTfX0gPle2wJHrsF_Y9hoePM_Q';
        // Store in Shared preferences
        return await _sharedPreferencesService.saveToken('Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2JhMmM2OTlmYWViNDVhMjYzYjIzMzhjYzkxMTlkMiIsIm5iZiI6MTQ5ODI2NzM3MC41MzksInN1YiI6IjU5NGRiZWU2OTI1MTQxMzExMTAyZDNkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FLzVpNzwWtjgBvVkynTfX0gPle2wJHrsF_Y9hoePM_Q');
      } else {
        _log.warning('Error logging in');
        return Result.error(Exception());
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      // Clear stored auth token
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.severe('Failed to clear stored auth token');
      }

      // Clear token in ApiClient
      _authToken = null;

      // Clear authenticated status
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
