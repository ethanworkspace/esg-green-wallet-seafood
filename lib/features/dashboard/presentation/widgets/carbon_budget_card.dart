import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/providers/dashboard_providers.dart';

class CarbonBudgetCard extends ConsumerWidget {
  const CarbonBudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final used = ref.watch(usedCarbonProvider);
    final remaining = ref.watch(remainingCarbonProvider);
    final percentage = (used / initialBudget * 100).clamp(0.0, 100.0);
    final isOverBudget = used >= initialBudget;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A2A), Color(0xFF0D2818)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── 標題列 ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.eco, color: AppTheme.primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                '本月碳預算',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '2026 年 5 月',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── 圓環圖 + 中心數字 ──
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 3,
                    centerSpaceRadius: 60,
                    sections: [
                      // 已使用
                      PieChartSectionData(
                        value: used.clamp(0.01, initialBudget),
                        color: isOverBudget
                            ? AppTheme.dangerRed
                            : const Color(0xFFFF7043),
                        radius: 22,
                        showTitle: false,
                      ),
                      // 剩餘
                      PieChartSectionData(
                        value: remaining.clamp(0.01, initialBudget),
                        color: AppTheme.primaryGreen,
                        radius: 22,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                // 中心數字
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remaining.toStringAsFixed(1),
                      style: TextStyle(
                        color: isOverBudget
                            ? AppTheme.dangerRed
                            : AppTheme.primaryGreen,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'kg CO₂e',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '剩餘額度',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 底部統計列 ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _buildStat(
                  label: '已使用',
                  value: '${used.toStringAsFixed(1)} kg',
                  color: const Color(0xFFFF7043),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _buildStat(
                  label: '總預算',
                  value: '${initialBudget.toInt()} kg',
                  color: Colors.white54,
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _buildStat(
                  label: '使用率',
                  value: '${percentage.toStringAsFixed(0)}%',
                  color: percentage > 80
                      ? AppTheme.dangerRed
                      : AppTheme.primaryGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
