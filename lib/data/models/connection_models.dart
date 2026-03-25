import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_models.freezed.dart';
part 'connection_models.g.dart';

@freezed
class TrainerSearchResult with _$TrainerSearchResult {
  const factory TrainerSearchResult({
    required int id,
    required String username,
    @JsonKey(name: 'full_name') required String fullName,
    String? photo,
    String? bio,
  }) = _TrainerSearchResult;

  factory TrainerSearchResult.fromJson(Map<String, dynamic> json) =>
      _$TrainerSearchResultFromJson(json);
}

@freezed
class ConnectionRequest with _$ConnectionRequest {
  const factory ConnectionRequest({
    required int id,
    required int trainer,
    @JsonKey(name: 'trainer_name') required String trainerName,
    required int client,
    @JsonKey(name: 'client_name') required String clientName,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'trainer_photo') String? trainerPhoto,
    @JsonKey(name: 'client_photo') String? clientPhoto,
    String? message,
  }) = _ConnectionRequest;

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$ConnectionRequestFromJson(json);
}

@freezed
class PlanRequest with _$PlanRequest {
  const factory PlanRequest({
    required int id,
    required int client,
    @JsonKey(name: 'client_name') required String clientName,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    int? trainer,
    @JsonKey(name: 'trainer_name') String? trainerName,
    String? message,
    String? notes,
  }) = _PlanRequest;

  factory PlanRequest.fromJson(Map<String, dynamic> json) =>
      _$PlanRequestFromJson(json);
}
