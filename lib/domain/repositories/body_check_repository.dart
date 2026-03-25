import 'package:palestra/data/models/body_check_model.dart';

abstract class BodyCheckRepository {
  Future<List<BodyCheckModel>> getBodyChecks();
  Future<BodyCheckModel> getBodyCheckDetail(int id);
  Future<int> createBodyCheck({
    required String title,
    required String date,
    String? notes,
    double? weightKg,
    double? bodyFatPercent,
  });
  Future<void> uploadPhoto({
    required int bodyCheckId,
    required String filePath,
    required String position,
    List<int>? bytes,
  });
  Future<void> deleteBodyCheck(int id);
  Future<void> addComment({
    required int bodyCheckId,
    required String message,
  });
  Future<void> shareWithTrainer({
    required int bodyCheckId,
    required int trainerId,
  });
}
