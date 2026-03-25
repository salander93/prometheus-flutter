import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<void> uploadPhoto(String filePath);
  Future<void> deletePhoto();
  Future<List<TrainerClient>> getMyClients();
  Future<List<TrainerClient>> getMyTrainers();
  Future<BodyMetric?> getLatestMetrics();
  Future<List<BodyMetric>> getMetricsHistory({String? timeRange});
  Future<BodyMetric> addMetric(Map<String, dynamic> data);
}
