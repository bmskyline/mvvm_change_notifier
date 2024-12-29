import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_api_model.freezed.dart';
part 'movie_detail_api_model.g.dart';

@freezed
class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({

    int? id,

    required String title,

    required String overview,

    @JsonKey(name: 'vote_count') required int voteCount,

    @JsonKey(name: 'poster_path') required String posterPath,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, Object?> json) =>
      _$MovieDetailModelFromJson(json);
}
