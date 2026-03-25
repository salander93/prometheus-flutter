import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  // Assume online if state is unknown to avoid false-offline UI.
  return connectivity.valueOrNull ?? true;
});
