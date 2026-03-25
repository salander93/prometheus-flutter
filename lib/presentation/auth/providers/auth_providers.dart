import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/api/api_client.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/core/storage/token_storage.dart';
import 'package:palestra/data/datasources/remote/auth_remote_datasource.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/data/repositories/auth_repository_impl.dart';
import 'package:palestra/domain/repositories/auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(
    tokenStorage: tokenStorage,
    onAuthFailure: () {
      ref.read(authStateProvider.notifier).state =
          const AsyncData(AuthState.unauthenticated);
    },
  );
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDatasource(dio: apiClient.dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

enum AuthState { unknown, authenticated, unauthenticated }

final authStateProvider =
    StateProvider<AsyncValue<AuthState>>(
  (ref) => const AsyncLoading(),
);

final authCheckProvider = FutureProvider<AuthState>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  final isAuth = await repo.isAuthenticated();
  if (!isAuth) return AuthState.unauthenticated;
  final refreshed = await repo.refreshToken();
  return refreshed ? AuthState.authenticated : AuthState.unauthenticated;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.valueOrNull != AuthState.authenticated) return null;

  final cachedApi = ref.watch(cachedApiProvider);
  final repo = ref.read(authRepositoryProvider);

  return cachedApi.fetch<UserModel>(
    cacheKey: 'user_me',
    apiCall: repo.getCurrentUser,
    fromCache: (json) =>
        UserModel.fromJson(json as Map<String, dynamic>),
    toCache: (data) => data.toJson(),
    ttl: const Duration(minutes: 10),
  );
});
