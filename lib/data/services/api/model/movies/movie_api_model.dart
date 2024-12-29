import 'package:freezed_annotation/freezed_annotation.dart';

import '../movie_detail/movie_detail_api_model.dart';

part 'movie_api_model.freezed.dart';
part 'movie_api_model.g.dart';

@freezed
class MoviesModel with _$MoviesModel {
  const factory MoviesModel({

    @JsonKey(name: 'results') required List<MovieDetailModel> movies,
  }) = _MoviesModel;

  factory MoviesModel.fromJson(Map<String, Object?> json) =>
      _$MoviesModelFromJson(json);
}
