// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      bio: json['bio'] as String?,
      birthDate: json['birth_date'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      shareBodyChecksWithTrainers:
          json['share_body_checks_with_trainers'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'role': instance.role,
      'phone': instance.phone,
      'photo': instance.photo,
      'bio': instance.bio,
      'birth_date': instance.birthDate,
      'height': instance.height,
      'age': instance.age,
      'share_body_checks_with_trainers': instance.shareBodyChecksWithTrainers,
    };
