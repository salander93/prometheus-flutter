import 'package:dio/dio.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/data/models/workout_models.dart';
import 'package:palestra/data/models/workout_plan_detail_model.dart';

class WorkoutRemoteDatasource {
  WorkoutRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<WorkoutPlanSummary>> getPlans() async {
    final r = await _dio.get<dynamic>('/api/workouts/plans/');
    return _parsePaginatedList(r.data, WorkoutPlanSummary.fromJson);
  }

  Future<WorkoutPlanDetail> getPlanDetail(int planId) async {
    final r = await _dio
        .get<Map<String, dynamic>>('/api/workouts/plans/$planId/');
    return WorkoutPlanDetail.fromJson(r.data!);
  }

  /// Returns null when no active workout is running.
  ///
  /// The backend returns `{"active": null}` (not a 404) when no execution
  /// is in progress.
  Future<WorkoutExecution?> getActiveExecution() async {
    final r = await _dio
        .get<Map<String, dynamic>>('/api/workouts/executions/active/');
    final data = r.data;
    if (data == null) return null;
    if (data.containsKey('active') && data['active'] == null) return null;
    return WorkoutExecution.fromJson(data);
  }

  Future<CalendarData> getCalendar({
    required int year,
    required int month,
  }) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/workouts/executions/calendar/',
      queryParameters: <String, dynamic>{'year': year, 'month': month},
    );
    return CalendarData.fromJson(r.data!);
  }

  Future<List<ActivityLogSummary>> getActivityLogs() async {
    final r = await _dio.get<dynamic>('/api/workouts/logs/');
    return _parsePaginatedList(r.data, ActivityLogSummary.fromJson);
  }

  // ── Exercise library ────────────────────────────────────────────────────

  Future<List<ExerciseModel>> getExercises({
    String? search,
    String? muscleGroup,
  }) async {
    final params = <String, dynamic>{
      if (search != null && search.isNotEmpty) 'search': search,
      if (muscleGroup != null && muscleGroup.isNotEmpty)
        'muscle_group': muscleGroup,
    };
    final r = await _dio.get<dynamic>(
      '/api/workouts/exercises/',
      queryParameters: params.isEmpty ? null : params,
    );
    return _parsePaginatedList(r.data, ExerciseModel.fromJson);
  }

  Future<ExerciseModel> getExerciseDetail(int exerciseId) async {
    final r = await _dio
        .get<Map<String, dynamic>>('/api/workouts/exercises/$exerciseId/');
    return ExerciseModel.fromJson(r.data!);
  }

  // ── Execution flow ──────────────────────────────────────────────────────

  /// Suggests the next session based on history.
  ///
  /// Calls `GET /api/workouts/executions/suggest/?plan_id={planId}`.
  Future<SessionSuggestionResponse> suggestSession(int planId) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/workouts/executions/suggest/',
      queryParameters: <String, dynamic>{'plan_id': planId},
    );
    return SessionSuggestionResponse.fromJson(r.data!);
  }

  /// Starts a new workout execution.
  ///
  /// Calls `POST /api/workouts/executions/start/`.
  Future<WorkoutExecutionDetail> startExecution({
    required int planId,
    required int sessionId,
    required int weekNumber,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/workouts/executions/start/',
      data: <String, dynamic>{
        'workout_plan': planId,
        'session': sessionId,
        'week_number': weekNumber,
      },
    );
    return WorkoutExecutionDetail.fromJson(r.data!);
  }

  Future<WorkoutExecutionDetail> getExecutionDetail(int executionId) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/workouts/executions/$executionId/',
    );
    return WorkoutExecutionDetail.fromJson(r.data!);
  }

  /// Completes an execution and returns the updated record.
  ///
  /// Calls `POST /api/workouts/executions/{id}/complete/`.
  Future<WorkoutExecutionDetail> completeExecution(
    int executionId, {
    int? feeling,
    String? notes,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/workouts/executions/$executionId/complete/',
      data: <String, dynamic>{
        if (feeling != null) 'feeling': feeling,
        if (notes != null) 'notes': notes,
      },
    );
    return WorkoutExecutionDetail.fromJson(r.data!);
  }

  /// Logs a set result.
  ///
  /// Calls `PATCH /api/workouts/executions/{id}/exercises/{eid}/sets/{sid}`.
  Future<ExerciseSet> logSet({
    required int executionId,
    required int exerciseExecutionId,
    required int setNumber,
    int? actualReps,
    double? actualWeight,
  }) async {
    final r = await _dio.patch<Map<String, dynamic>>(
      '/api/workouts/executions/$executionId'
      '/exercises/$exerciseExecutionId'
      '/sets/$setNumber/',
      data: <String, dynamic>{
        if (actualReps != null) 'actual_reps': actualReps,
        if (actualWeight != null) 'actual_weight': actualWeight,
        'completed': true,
      },
    );
    return ExerciseSet.fromJson(r.data!);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  List<T> _parsePaginatedList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> list;
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      list = data['results'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
