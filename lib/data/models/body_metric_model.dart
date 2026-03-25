import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_metric_model.freezed.dart';
part 'body_metric_model.g.dart';

@freezed
class BodyMetric with _$BodyMetric {
  const factory BodyMetric({
    required int id,
    @JsonKey(name: 'recorded_at') required String recordedAt,
    @JsonKey(name: 'created_at') required String createdAt,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? shoulders,
    double? neck,
    @JsonKey(name: 'biceps_left') double? bicepsLeft,
    @JsonKey(name: 'biceps_right') double? bicepsRight,
    @JsonKey(name: 'thigh_left') double? thighLeft,
    @JsonKey(name: 'thigh_right') double? thighRight,
    @JsonKey(name: 'calf_left') double? calfLeft,
    @JsonKey(name: 'calf_right') double? calfRight,
    @JsonKey(name: 'forearm_left') double? forearmLeft,
    @JsonKey(name: 'forearm_right') double? forearmRight,
    String? notes,
  }) = _BodyMetric;

  factory BodyMetric.fromJson(Map<String, dynamic> json) =>
      _$BodyMetricFromJson(json);
}
