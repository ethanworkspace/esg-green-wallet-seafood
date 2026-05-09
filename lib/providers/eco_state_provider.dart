import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/dashboard/data/providers/dashboard_providers.dart';

/// 生態池健康狀態
enum EcoState {
  /// 碳預算 > 60% — 清澈、生機盎然
  thriving,

  /// 碳預算 20%–60% — 水質混濁、發出警戒
  warning,

  /// 碳預算 < 20% — 嚴重污染、生物瀕危
  critical,
}

/// 碳預算使用百分比 (0.0 ~ 1.0)
final carbonUsageRatioProvider = Provider<double>((ref) {
  final used = ref.watch(usedCarbonProvider);
  return (used / initialBudget).clamp(0.0, 1.0);
});

/// 碳預算剩餘百分比 (0.0 ~ 1.0)
final carbonRemainingRatioProvider = Provider<double>((ref) {
  return 1.0 - ref.watch(carbonUsageRatioProvider);
});

/// 根據碳預算剩餘百分比衍生出生態狀態
final ecoStateProvider = Provider<EcoState>((ref) {
  final remainingRatio = ref.watch(carbonRemainingRatioProvider);

  if (remainingRatio > 0.6) return EcoState.thriving;
  if (remainingRatio > 0.2) return EcoState.warning;
  return EcoState.critical;
});
