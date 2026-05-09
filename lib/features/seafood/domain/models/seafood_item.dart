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
