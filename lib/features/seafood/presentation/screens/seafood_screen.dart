import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/seafood_item.dart';
import '../../../../repositories/seafood_repository.dart';
import '../widgets/seafood_selector.dart';
import '../widgets/seafood_comparison_chart.dart';

class SeafoodScreen extends ConsumerWidget {
  const SeafoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seafoodList = ref.watch(seafoodListProvider);
    final indexA = ref.watch(selectedSeafoodAProvider);
    final indexB = ref.watch(selectedSeafoodBProvider);
    final itemA = seafoodList[indexA];
    final itemB = seafoodList[indexB];
    final reduction = ref.watch(carbonReductionProvider);
    final isSame = itemA.name == itemB.name;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 標題 ──
            Text(
              '海鮮碳排比較',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              '比較不同海鮮的碳排放量，做出更環保的選擇',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white38,
                  ),
            ),

            const SizedBox(height: 24),

            // ── 選擇器 ──
            const SeafoodSelector(),

            const SizedBox(height: 28),

            // ── 比較圖表 ──
            SeafoodComparisonChart(itemA: itemA, itemB: itemB),

            // ── 獎勵點數卡片 ──
            if (!isSame && reduction.rewardPoints > 0) ...[
              const SizedBox(height: 20),
              _buildRewardCard(context, reduction),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, CarbonReductionResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A40), Color(0xFF252560)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFD600).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD600).withValues(alpha: 0.08),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          // 獎牌圖示
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFFFD600),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎉 綠色獎勵點數',
                  style: TextStyle(
                    color: Color(0xFFFFD600),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: '選擇低碳品項可獲得 '),
                      TextSpan(
                        text: '+${result.rewardPoints} 點',
                        style: const TextStyle(
                          color: Color(0xFFFFD600),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '減碳 ${result.reductionPerKg.toStringAsFixed(1)} kg · '
                  '減少 ${result.reductionPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
