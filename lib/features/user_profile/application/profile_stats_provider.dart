import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../history/application/history_providers.dart';

class ProfileStats {
  final int totalTryOns;
  final int thisMonthTryOns;
  final DateTime? memberSince;

  const ProfileStats({
    required this.totalTryOns,
    required this.thisMonthTryOns,
    this.memberSince,
  });
}

final profileStatsProvider = Provider<ProfileStats>((ref) {
  final history = ref.watch(historyProvider).value ?? [];

  final now = DateTime.now();
  final thisMonth = history.where((item) =>
      item.createdAt.year == now.year && item.createdAt.month == now.month);

  DateTime? earliest;
  for (final item in history) {
    if (earliest == null || item.createdAt.isBefore(earliest)) {
      earliest = item.createdAt;
    }
  }

  return ProfileStats(
    totalTryOns: history.length,
    thisMonthTryOns: thisMonth.length,
    memberSince: earliest,
  );
});