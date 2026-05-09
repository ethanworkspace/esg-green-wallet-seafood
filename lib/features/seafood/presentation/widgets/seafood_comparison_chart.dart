import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/seafood_item.dart';

class SeafoodComparisonChart extends StatefulWidget {
  final SeafoodItem itemA;
  final SeafoodItem itemB;

  const SeafoodComparisonChart({
    super.key,
    required this.itemA,
    required this.itemB,
  });

  @override
  State<SeafoodComparisonChart> createState() => _SeafoodComparisonChartState();
}

class _SeafoodComparisonChartState extends State<SeafoodComparisonChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SeafoodComparisonChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemA.name != widget.itemA.name ||
        oldWidget.itemB.name != widget.itemB.name) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.itemA;
    final b = widget.itemB;
    final maxVal = [a.carbonFootprint, b.carbonFootprint]
        .reduce((x, y) => x > y ? x : y);
    final diff = (a.carbonFootprint - b.carbonFootprint).abs();
    final aIsLower = a.carbonFootprint < b.carbonFootprint;
    final bIsLower = b.carbonFootprint < a.carbonFootprint;
    final isSame = a.name == b.name;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final progress = _animation.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 圖表標題 ──
            Text(
              '碳排放量比較',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              '單位: kg CO₂e / kg 海鮮',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white38,
                  ),
            ),

            const SizedBox(height: 24),

            // ── Bar A ──
            _buildBar(
              label: a.name,
              value: a.carbonFootprint,
              maxValue: maxVal,
              progress: progress,
              isLower: aIsLower && !isSame,
              color: aIsLower && !isSame
                  ? AppTheme.primaryGreen
                  : const Color(0xFFFF7043),
            ),

            const SizedBox(height: 16),

            // ── Bar B ──
            _buildBar(
              label: b.name,
              value: b.carbonFootprint,
              maxValue: maxVal,
              progress: progress,
              isLower: bIsLower && !isSame,
              color: bIsLower && !isSame
                  ? AppTheme.primaryGreen
                  : const Color(0xFFFF7043),
            ),

            const SizedBox(height: 24),

            // ── 結果訊息 ──
            if (!isSame)
              _buildResultMessage(
                context: context,
                winner: aIsLower ? a : b,
                diff: diff,
              ),

            if (isSame)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '請選擇不同的海鮮品項來比較',
                        style: TextStyle(
                          color: Colors.amber.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // ── 詳細資訊卡 ──
            if (!isSame) ...[
              _buildDetailCard(a, aIsLower),
              const SizedBox(height: 10),
              _buildDetailCard(b, bIsLower),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBar({
    required String label,
    required double value,
    required double maxValue,
    required double progress,
    required bool isLower,
    required Color color,
  }) {
    final fraction = (value / maxValue) * progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isLower ? AppTheme.primaryGreen : Colors.white70,
                  fontWeight: isLower ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(1)} kg',
              style: TextStyle(
                color: isLower ? AppTheme.primaryGreen : Colors.white54,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // 背景
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            // 前景 bar
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  gradient: isLower
                      ? const LinearGradient(
                          colors: [Color(0xFF00C853), Color(0xFF00E676)])
                      : LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.8),
                            color,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: fraction > 0.15
                    ? Icon(
                        isLower ? Icons.eco : Icons.local_fire_department,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultMessage({
    required BuildContext context,
    required SeafoodItem winner,
    required double diff,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D3320), Color(0xFF0A2818)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.emoji_nature,
              color: AppTheme.primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: '選擇 '),
                  TextSpan(
                    text: winner.name,
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: '\n可為地球省下 '),
                  TextSpan(
                    text: '${diff.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const TextSpan(text: ' 的碳排！'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(SeafoodItem item, bool isLower) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLower
              ? AppTheme.primaryGreen.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          // 左側圖示
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLower
                  ? AppTheme.primaryGreen.withValues(alpha: 0.15)
                  : const Color(0xFFFF7043).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.set_meal,
              color: isLower ? AppTheme.primaryGreen : const Color(0xFFFF7043),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // 資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: isLower ? AppTheme.primaryGreen : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.origin} · ${item.productionMethod} · ${item.transportMode}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 碳排數值
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isLower
                  ? AppTheme.primaryGreen.withValues(alpha: 0.15)
                  : const Color(0xFFFF7043).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${item.carbonFootprint} kg',
              style: TextStyle(
                color: isLower ? AppTheme.primaryGreen : const Color(0xFFFF7043),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
