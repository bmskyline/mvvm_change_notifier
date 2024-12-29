// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieDetailModelImpl _$$MovieDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MovieDetailModelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      voteCount: (json['vote_count'] as num).toInt(),
      posterPath: json['poster_path'] as String,
    );

Map<String, dynamic> _$$MovieDetailModelImplToJson(
        _$MovieDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'vote_count': instance.voteCount,
      'poster_path': instance.posterPath,
    };
