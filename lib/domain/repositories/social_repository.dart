import 'package:palestra/data/models/connection_models.dart';

abstract class SocialRepository {
  Future<List<TrainerSearchResult>> searchTrainers({
    String? query,
    String? code,
  });

  Future<List<ConnectionRequest>> getConnectionRequests();

  Future<void> sendConnectionRequest({
    required int trainerId,
    String? message,
  });

  Future<void> acceptConnectionRequest(int requestId);

  Future<void> rejectConnectionRequest(int requestId);

  Future<List<PlanRequest>> getPlanRequests();

  Future<void> createPlanRequest({
    required int trainerId,
    String? message,
  });

  Future<void> acceptPlanRequest(int requestId);

  Future<void> rejectPlanRequest(int requestId);
}
