import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_metric_model.freezed.dart';
part 'body_metric_model.g.dart';

@freezed
class BodyMetric with _$BodyMetric {
  const factory BodyMetric({
    required int id,
    @JsonKey(name: 'recorded_at') required String recordedAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(fromJson: _doubleFromJson) double? weight,
    @JsonKey(fromJson: _doubleFromJson) double? chest,
    @JsonKey(fromJson: _doubleFromJson) double? waist,
    @JsonKey(fromJson: _doubleFromJson) double? hips,
    @JsonKey(fromJson: _doubleFromJson) double? shoulders,
    @JsonKey(fromJson: _doubleFromJson) double? neck,
    @JsonKey(name: 'biceps_left', fromJson: _doubleFromJson)
    double? bicepsLeft,
    @JsonKey(name: 'biceps_right', fromJson: _doubleFromJson)
    double? bicepsRight,
    @JsonKey(name: 'thigh_left', fromJson: _doubleFromJson)
    double? thighLeft,
    @JsonKey(name: 'thigh_right', fromJson: _doubleFromJson)
    double? thighRight,
    @JsonKey(name: 'calf_left', fromJson: _doubleFromJson) double? calfLeft,
    @JsonKey(name: 'calf_right', fromJson: _doubleFromJson)
    double? calfRight,
    @JsonKey(name: 'forearm_left', fromJson: _doubleFromJson)
    double? forearmLeft,
    @JsonKey(name: 'forearm_right', fromJson: _doubleFromJson)
    double? forearmRight,
    String? notes,
  }) = _BodyMetric;

  factory BodyMetric.fromJson(Map<String, dynamic> json) =>
      _$BodyMetricFromJson(json);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
