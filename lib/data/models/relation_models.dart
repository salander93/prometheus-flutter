import 'package:freezed_annotation/freezed_annotation.dart';

part 'relation_models.freezed.dart';
part 'relation_models.g.dart';

@freezed
class TrainerClient with _$TrainerClient {
  const factory TrainerClient({
    required int id,
    required int trainer,
    @JsonKey(name: 'trainer_name') required String trainerName,
    required int client,
    @JsonKey(name: 'client_name') required String clientName,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'trainer_photo') String? trainerPhoto,
    @JsonKey(name: 'client_photo') String? clientPhoto,
  }) = _TrainerClient;

  factory TrainerClient.fromJson(Map<String, dynamic> json) =>
      _$TrainerClientFromJson(json);
}
