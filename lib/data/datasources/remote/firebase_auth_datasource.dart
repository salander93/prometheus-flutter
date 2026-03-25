import 'package:dio/dio.dart';
import 'package:palestra/data/models/auth_models.dart';

/// Datasource for Firebase-based authentication (e.g. Google Sign-In).
class FirebaseAuthDatasource {
  FirebaseAuthDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Send Firebase ID token to backend, get back JWT tokens.
  Future<LoginResponse> authenticateWithFirebase(
    String firebaseIdToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/firebase/',
      data: {'firebase_token': firebaseIdToken},
    );
    return LoginResponse.fromJson(response.data!);
  }
}
