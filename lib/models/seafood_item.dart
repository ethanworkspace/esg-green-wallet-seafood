/// 海鮮品項資料模型
class SeafoodItem {
  final String name;
  final String category;
  final String origin;
  final String productionMethod;
  final String transportMode;
  final double carbonFootprint; // kg CO₂e/kg

  const SeafoodItem({
    required this.name,
    required this.category,
    required this.origin,
    required this.productionMethod,
    required this.transportMode,
    required this.carbonFootprint,
  });
}

/// 減碳比較結果
class CarbonReductionResult {
  /// 基準品項（高碳排）
  final SeafoodItem baseline;

  /// 替代品項（低碳排）
  final SeafoodItem alternative;

  /// 每公斤減碳量 (kg CO₂e)
  final double reductionPerKg;

  /// 可換算的獎勵點數
  final int rewardPoints;

  /// 減碳百分比
  final double reductionPercentage;

  const CarbonReductionResult({
    required this.baseline,
    required this.alternative,
    required this.reductionPerKg,
    required this.rewardPoints,
    required this.reductionPercentage,
  });
}

/// 計算兩個海鮮品項之間的減碳差值，並轉換為獎勵點數
///
/// 規則：
/// - 每減少 1 kg CO₂e → 10 點獎勵
/// - 若 [chosen] 碳排 >= [compared]，則無減碳效益，回傳 0 點
/// - [purchaseKg] 為購買公斤數，預設 1 kg
CarbonReductionResult calculateCarbonReduction({
  required SeafoodItem chosen,
  required SeafoodItem compared,
  double purchaseKg = 1.0,
}) {
  final isChosenLower = chosen.carbonFootprint < compared.carbonFootprint;

  final baseline = isChosenLower ? compared : chosen;
  final alternative = isChosenLower ? chosen : compared;

  final reductionPerKg = baseline.carbonFootprint - alternative.carbonFootprint;
  final totalReduction = reductionPerKg * purchaseKg;

  // 每減少 1 kg CO₂e = 10 點
  const double pointsPerKgReduction = 10.0;
  final points = isChosenLower
      ? (totalReduction * pointsPerKgReduction).round()
      : 0;

  final percentage = baseline.carbonFootprint > 0
      ? (reductionPerKg / baseline.carbonFootprint) * 100
      : 0.0;

  return CarbonReductionResult(
    baseline: baseline,
    alternative: alternative,
    reductionPerKg: reductionPerKg,
    rewardPoints: points,
    reductionPercentage: percentage,
  );
}
