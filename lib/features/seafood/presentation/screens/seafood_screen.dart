import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/seafood_repository.dart';
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
          ],
        ),
      ),
    );
  }
}
