import 'package:palestra/data/datasources/remote/body_check_remote_datasource.dart';
import 'package:palestra/data/models/body_check_model.dart';
import 'package:palestra/domain/repositories/body_check_repository.dart';

class BodyCheckRepositoryImpl implements BodyCheckRepository {
  BodyCheckRepositoryImpl({required BodyCheckRemoteDatasource remoteDatasource})
      : _remote = remoteDatasource;

  final BodyCheckRemoteDatasource _remote;

  @override
  Future<List<BodyCheckModel>> getBodyChecks() => _remote.getBodyChecks();

  @override
  Future<BodyCheckModel> getBodyCheckDetail(int id) =>
      _remote.getBodyCheckDetail(id);

  @override
  Future<int> createBodyCheck({
    required String title,
    required String date,
    String? notes,
    double? weightKg,
    double? bodyFatPercent,
  }) =>
      _remote.createBodyCheck(
        title: title,
        date: date,
        notes: notes,
        weightKg: weightKg,
        bodyFatPercent: bodyFatPercent,
      );

  @override
  Future<void> uploadPhoto({
    required int bodyCheckId,
    required String filePath,
    required String position,
    List<int>? bytes,
  }) =>
      _remote.uploadPhoto(
        bodyCheckId: bodyCheckId,
        filePath: filePath,
        position: position,
        bytes: bytes,
      );

  @override
  Future<void> deleteBodyCheck(int id) => _remote.deleteBodyCheck(id);

  @override
  Future<void> addComment({
    required int bodyCheckId,
    required String message,
  }) =>
      _remote.addComment(bodyCheckId: bodyCheckId, message: message);

  @override
  Future<void> shareWithTrainer({
    required int bodyCheckId,
    required int trainerId,
  }) =>
      _remote.shareWithTrainer(
        bodyCheckId: bodyCheckId,
        trainerId: trainerId,
      );
}
