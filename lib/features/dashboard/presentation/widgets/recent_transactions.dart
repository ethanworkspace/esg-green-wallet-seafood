import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// 硬編碼示範交易資料
class _Transaction {
  final String title;
  final String subtitle;
  final double co2;
  final IconData icon;
  final Color iconColor;

  const _Transaction({
    required this.title,
    required this.subtitle,
    required this.co2,
    required this.icon,
    required this.iconColor,
  });
}

const _mockTransactions = [
  _Transaction(
    title: '超市購物',
    subtitle: '全聯福利中心 · 今天',
    co2: 3.2,
    icon: Icons.shopping_cart_outlined,
    iconColor: Color(0xFF42A5F5),
  ),
  _Transaction(
    title: '午餐 - 牛排',
    subtitle: '王品牛排 · 昨天',
    co2: 12.5,
    icon: Icons.restaurant_outlined,
    iconColor: Color(0xFFFF7043),
  ),
  _Transaction(
    title: '通勤 - 捷運',
    subtitle: '台北捷運 · 昨天',
    co2: 0.8,
    icon: Icons.train_outlined,
    iconColor: AppTheme.primaryGreen,
  ),
  _Transaction(
    title: '海鮮 - 鮭魚',
    subtitle: '上引水產 · 3 天前',
    co2: 5.4,
    icon: Icons.set_meal_outlined,
    iconColor: Color(0xFF26C6DA),
  ),
  _Transaction(
    title: '外送餐點',
    subtitle: 'Uber Eats · 4 天前',
    co2: 7.1,
    icon: Icons.delivery_dining_outlined,
    iconColor: Color(0xFFAB47BC),
  ),
];

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: _mockTransactions.length,
      itemBuilder: (context, index) {
        final tx = _mockTransactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                // ── 圖示 ──
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tx.iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tx.icon, color: tx.iconColor, size: 22),
                ),
                const SizedBox(width: 14),

                // ── 文字 ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tx.subtitle,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CO2 數值 ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: tx.co2 > 10
                        ? AppTheme.dangerRed.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${tx.co2} kg',
                    style: TextStyle(
                      color: tx.co2 > 10 ? AppTheme.dangerRed : Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
