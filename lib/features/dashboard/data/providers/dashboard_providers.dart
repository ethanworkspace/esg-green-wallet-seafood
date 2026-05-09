import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 模擬交易紀錄
class TransactionRecord {
  final String title;
  final String subtitle;
  final double co2;
  final IconData icon;
  final Color iconColor;
  final bool hasLowCarbonAlt; // 是否有低碳替代品

  const TransactionRecord({
    required this.title,
    required this.subtitle,
    required this.co2,
    required this.icon,
    required this.iconColor,
    this.hasLowCarbonAlt = false,
  });
}

const List<TransactionRecord> mockTransactions = [
  TransactionRecord(
    title: '超市購物',
    subtitle: '全聯福利中心 · 今天',
    co2: 3.2,
    icon: Icons.shopping_cart_outlined,
    iconColor: Color(0xFF42A5F5),
  ),
  TransactionRecord(
    title: '午餐 — 進口鮭魚定食',
    subtitle: '王品牛排 · 昨天',
    co2: 12.5,
    icon: Icons.restaurant_outlined,
    iconColor: Color(0xFFFF7043),
    hasLowCarbonAlt: true,
  ),
  TransactionRecord(
    title: '通勤 — 捷運',
    subtitle: '台北捷運 · 昨天',
    co2: 0.8,
    icon: Icons.train_outlined,
    iconColor: Color(0xFF00C853),
  ),
  TransactionRecord(
    title: '海鮮 — 進口鮭魚',
    subtitle: '上引水產 · 3 天前',
    co2: 5.4,
    icon: Icons.set_meal_outlined,
    iconColor: Color(0xFF26C6DA),
    hasLowCarbonAlt: true,
  ),
  TransactionRecord(
    title: '外送餐點',
    subtitle: 'Uber Eats · 4 天前',
    co2: 7.1,
    icon: Icons.delivery_dining_outlined,
    iconColor: Color(0xFFAB47BC),
  ),
];

/// 起始碳預算
const double initialBudget = 50.0;

/// 已使用碳排（從交易累加）
final usedCarbonProvider = Provider<double>((ref) {
  return mockTransactions.fold(0.0, (sum, tx) => sum + tx.co2);
});

/// 剩餘碳預算
final remainingCarbonProvider = Provider<double>((ref) {
  final used = ref.watch(usedCarbonProvider);
  return (initialBudget - used).clamp(0.0, initialBudget);
});

/// 交易列表 Provider
final transactionsProvider = Provider<List<TransactionRecord>>((ref) {
  return mockTransactions;
});
