import 'package:palestra/data/datasources/remote/user_remote_datasource.dart';
import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/data/models/relation_models.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserRemoteDatasource remoteDatasource})
      : _remote = remoteDatasource;

  final UserRemoteDatasource _remote;

  @override
  Future<UserModel> getProfile() => _remote.getProfile();

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) =>
      _remote.updateProfile(data);

  @override
  Future<void> uploadPhoto(String filePath) => _remote.uploadPhoto(filePath);

  @override
  Future<void> deletePhoto() => _remote.deletePhoto();

  @override
  Future<List<TrainerClient>> getMyClients() => _remote.getMyClients();

  @override
  Future<List<TrainerClient>> getMyTrainers() => _remote.getMyTrainers();

  @override
  Future<BodyMetric?> getLatestMetrics() => _remote.getLatestMetrics();

  @override
  Future<List<BodyMetric>> getMetricsHistory({String? timeRange}) =>
      _remote.getMetricsHistory(timeRange: timeRange);

  @override
  Future<BodyMetric> addMetric(Map<String, dynamic> data) =>
      _remote.addMetric(data);
}
