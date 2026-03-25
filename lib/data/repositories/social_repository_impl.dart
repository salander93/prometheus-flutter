import 'package:palestra/data/datasources/remote/social_remote_datasource.dart';
import 'package:palestra/data/models/connection_models.dart';
import 'package:palestra/domain/repositories/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl({required SocialRemoteDatasource remoteDatasource})
      : _remote = remoteDatasource;

  final SocialRemoteDatasource _remote;

  @override
  Future<List<TrainerSearchResult>> searchTrainers({
    String? query,
    String? code,
  }) =>
      _remote.searchTrainers(query: query, code: code);

  @override
  Future<List<ConnectionRequest>> getConnectionRequests() =>
      _remote.getConnectionRequests();

  @override
  Future<void> sendConnectionRequest({
    required int trainerId,
    String? message,
  }) =>
      _remote.sendConnectionRequest(trainerId: trainerId, message: message);

  @override
  Future<void> acceptConnectionRequest(int requestId) =>
      _remote.updateConnectionRequestStatus(requestId, 'ACCEPTED');

  @override
  Future<void> rejectConnectionRequest(int requestId) =>
      _remote.updateConnectionRequestStatus(requestId, 'REJECTED');

  @override
  Future<List<PlanRequest>> getPlanRequests() => _remote.getPlanRequests();

  @override
  Future<void> createPlanRequest({
    required int trainerId,
    String? message,
  }) =>
      _remote.createPlanRequest(trainerId: trainerId, message: message);

  @override
  Future<void> acceptPlanRequest(int requestId) =>
      _remote.updatePlanRequestStatus(requestId, 'ACCEPTED');

  @override
  Future<void> rejectPlanRequest(int requestId) =>
      _remote.updatePlanRequestStatus(requestId, 'REJECTED');
}
