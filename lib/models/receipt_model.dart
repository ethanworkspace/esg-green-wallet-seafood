/// 發票品項
class ReceiptItem {
  final String name;
  final double amount; // 金額 (NTD)
  final double estimatedCO2; // 預估碳排 (kg CO₂e)
  final bool hasLowCarbonAlt;

  const ReceiptItem({
    required this.name,
    required this.amount,
    required this.estimatedCO2,
    this.hasLowCarbonAlt = false,
  });
}

/// 電子發票資料模型
class Receipt {
  final String id;
  final DateTime date;
  final String storeName;
  final List<ReceiptItem> items;

  const Receipt({
    required this.id,
    required this.date,
    required this.storeName,
    required this.items,
  });

  /// 該筆發票的總金額
  double get totalAmount => items.fold(0.0, (sum, i) => sum + i.amount);

  /// 該筆發票的總碳排
  double get totalCO2 => items.fold(0.0, (sum, i) => sum + i.estimatedCO2);
}
