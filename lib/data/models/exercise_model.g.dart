// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseModelImpl _$$ExerciseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      muscleGroup: json['muscle_group'] as String,
      muscleGroupDisplay: json['muscle_group_display'] as String,
      level: json['level'] as String,
      levelDisplay: json['level_display'] as String,
      category: json['category'] as String,
      categoryDisplay: json['category_display'] as String,
      isPublic: json['is_public'] as bool,
      createdAt: json['created_at'] as String,
      nameIt: json['name_it'] as String?,
      description: json['description'] as String?,
      instructions: json['instructions'] as String?,
      secondaryMuscles: json['secondary_muscles'] as String?,
      equipment: json['equipment'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      isOwner: json['is_owner'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExerciseModelImplToJson(_$ExerciseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'muscle_group': instance.muscleGroup,
      'muscle_group_display': instance.muscleGroupDisplay,
      'level': instance.level,
      'level_display': instance.levelDisplay,
      'category': instance.category,
      'category_display': instance.categoryDisplay,
      'is_public': instance.isPublic,
      'created_at': instance.createdAt,
      'name_it': instance.nameIt,
      'description': instance.description,
      'instructions': instance.instructions,
      'secondary_muscles': instance.secondaryMuscles,
      'equipment': instance.equipment,
      'image': instance.image,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'is_owner': instance.isOwner,
    };
