abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const movie = '/$movieRelative';
  static const movieRelative = 'movie';
  static String movieWithId(int id) => '/$id';
}
