import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streams whether the device currently has any network connectivity
/// (wifi or mobile data). Used to show a global "no internet" banner
/// so the user understands why things like the profile photo or AI
/// generation aren't working, instead of seeing broken image icons.
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map((results) {
    return !results.contains(ConnectivityResult.none);
  });
});

/// One-shot check for the current connectivity state, useful for initial
/// screen builds before the stream emits its first value.
final isConnectedProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return !result.contains(ConnectivityResult.none);
});