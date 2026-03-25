import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'full_name') required String fullName,
    required String role,
    String? phone,
    String? photo,
    String? bio,
    @JsonKey(name: 'birth_date') String? birthDate,
    double? height,
    int? age,
    @JsonKey(name: 'share_body_checks_with_trainers')
    @Default(false)
    bool shareBodyChecksWithTrainers,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
