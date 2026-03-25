import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_model.freezed.dart';
part 'exercise_model.g.dart';

@freezed
class ExerciseModel with _$ExerciseModel {
  const factory ExerciseModel({
    required int id,
    required String name,
    @JsonKey(name: 'muscle_group') required String muscleGroup,
    @JsonKey(name: 'muscle_group_display') required String muscleGroupDisplay,
    required String level,
    @JsonKey(name: 'level_display') required String levelDisplay,
    required String category,
    @JsonKey(name: 'category_display') required String categoryDisplay,
    @JsonKey(name: 'is_public') required bool isPublic,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'name_it') String? nameIt,
    String? description,
    String? instructions,
    @JsonKey(name: 'secondary_muscles') String? secondaryMuscles,
    String? equipment,
    String? image,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'is_owner') @Default(false) bool isOwner,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}
