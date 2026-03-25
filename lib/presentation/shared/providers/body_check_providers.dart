import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/storage/cache_providers.dart';
import 'package:palestra/data/datasources/remote/body_check_remote_datasource.dart';
import 'package:palestra/data/models/body_check_model.dart';
import 'package:palestra/data/repositories/body_check_repository_impl.dart';
import 'package:palestra/domain/repositories/body_check_repository.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';

final bodyCheckRemoteDatasourceProvider =
    Provider<BodyCheckRemoteDatasource>((ref) {
  return BodyCheckRemoteDatasource(
    dio: ref.watch(apiClientProvider).dio,
  );
});

final bodyCheckRepositoryProvider = Provider<BodyCheckRepository>((ref) {
  return BodyCheckRepositoryImpl(
    remoteDatasource: ref.watch(bodyCheckRemoteDatasourceProvider),
  );
});

final bodyChecksProvider =
    FutureProvider<List<BodyCheckModel>>((ref) async {
  final repo = ref.watch(bodyCheckRepositoryProvider);
  return repo.getBodyChecks();
});

final bodyCheckDetailProvider =
    FutureProvider.family<BodyCheckModel, int>((ref, id) async {
  return ref.watch(bodyCheckRepositoryProvider).getBodyCheckDetail(id);
});
