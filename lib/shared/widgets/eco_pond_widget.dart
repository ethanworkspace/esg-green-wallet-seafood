import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/eco_state_provider.dart';
import '../../core/theme/app_theme.dart';

/// ─────────────────────────────────────────────
/// 虛擬生態雙生池 (Eco-Twin Aquarium)
/// ─────────────────────────────────────────────
class EcoPondWidget extends ConsumerStatefulWidget {
  const EcoPondWidget({super.key});

  @override
  ConsumerState<EcoPondWidget> createState() => _EcoPondWidgetState();
}

class _EcoPondWidgetState extends ConsumerState<EcoPondWidget>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _fishController;
  late final AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();

    // 水面波紋循環動畫
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // 魚類來回游動
    _fishController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // 氣泡上浮動畫
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fishController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // ── 狀態對應的視覺參數 ──

  List<Color> _pondGradient(EcoState state) => switch (state) {
        EcoState.thriving => const [
            Color(0xFF004D40),
            Color(0xFF00695C),
            Color(0xFF00897B),
          ],
        EcoState.warning => const [
            Color(0xFF4A4520),
            Color(0xFF5D5A28),
            Color(0xFF6D6930),
          ],
        EcoState.critical => const [
            Color(0xFF2C2C2C),
            Color(0xFF3A3A3A),
            Color(0xFF424242),
          ],
      };

  Color _waterSurfaceColor(EcoState state) => switch (state) {
        EcoState.thriving => const Color(0xFF26A69A).withValues(alpha: 0.35),
        EcoState.warning => const Color(0xFFCDDC39).withValues(alpha: 0.25),
        EcoState.critical => const Color(0xFF757575).withValues(alpha: 0.20),
      };

  Color _borderColor(EcoState state) => switch (state) {
        EcoState.thriving => AppTheme.primaryGreen.withValues(alpha: 0.5),
        EcoState.warning => const Color(0xFFFFD54F).withValues(alpha: 0.5),
        EcoState.critical => AppTheme.dangerRed.withValues(alpha: 0.5),
      };

  String _statusLabel(EcoState state) => switch (state) {
        EcoState.thriving => '🌊 生態繁榮',
        EcoState.warning => '⚡ 水質警戒',
        EcoState.critical => '⚠️ 生態危機',
      };

  Color _statusLabelColor(EcoState state) => switch (state) {
        EcoState.thriving => AppTheme.primaryGreen,
        EcoState.warning => const Color(0xFFFFD54F),
        EcoState.critical => AppTheme.dangerRed,
      };

  @override
  Widget build(BuildContext context) {
    final ecoState = ref.watch(ecoStateProvider);
    final remainingRatio = ref.watch(carbonRemainingRatioProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _pondGradient(ecoState),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderColor(ecoState), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _borderColor(ecoState).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 狀態標題列 ──
          _buildHeader(ecoState, remainingRatio),

          const SizedBox(height: 12),

          // ── 水池本體 ──
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: Stack(
                children: [
                  // 水底背景
                  _buildWaterBackground(ecoState),

                  // 波紋效果
                  _buildWaveOverlay(ecoState),

                  // 氣泡
                  if (ecoState != EcoState.critical) _buildBubbles(ecoState),

                  // 水底石頭 / 水草
                  _buildSeabed(ecoState),

                  // 魚群
                  _buildFish(ecoState),

                  // 危機警示覆蓋
                  if (ecoState == EcoState.critical) _buildCriticalOverlay(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── 底部提示文字 ──
          _buildFooterHint(ecoState),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━ Sub-widgets ━━━━━━━━━━━━━━━━━━━━

  Widget _buildHeader(EcoState state, double remainingRatio) {
    return Row(
      children: [
        // 狀態標籤
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _statusLabelColor(state).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _statusLabelColor(state).withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            _statusLabel(state),
            style: TextStyle(
              color: _statusLabelColor(state),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const Spacer(),

        // 剩餘碳預算
        Text(
          '碳預算 ${(remainingRatio * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterBackground(EcoState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            _waterSurfaceColor(state),
            _pondGradient(state).last.withValues(alpha: 0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveOverlay(EcoState state) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 170),
          painter: _WavePainter(
            animationValue: _waveController.value,
            waveColor: _waterSurfaceColor(state),
            waveCount: state == EcoState.thriving ? 3 : 2,
          ),
        );
      },
    );
  }

  Widget _buildBubbles(EcoState state) {
    return AnimatedBuilder(
      animation: _bubbleController,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(double.infinity, 170),
          painter: _BubblePainter(
            animationValue: _bubbleController.value,
            bubbleColor: state == EcoState.thriving
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.10),
          ),
        );
      },
    );
  }

  Widget _buildSeabed(EcoState state) {
    final seabedOpacity = switch (state) {
      EcoState.thriving => 0.7,
      EcoState.warning => 0.4,
      EcoState.critical => 0.2,
    };

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: seabedOpacity,
        child: const SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('🪸', style: TextStyle(fontSize: 22)),
              Text('🌿', style: TextStyle(fontSize: 18)),
              Text('🪨', style: TextStyle(fontSize: 16)),
              Text('🌿', style: TextStyle(fontSize: 20)),
              Text('🪸', style: TextStyle(fontSize: 18)),
              Text('🌿', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFish(EcoState state) {
    final fishOpacity = switch (state) {
      EcoState.thriving => 1.0,
      EcoState.warning => 0.6,
      EcoState.critical => 0.25,
    };

    return AnimatedBuilder(
      animation: _fishController,
      builder: (context, _) {
        final progress = _fishController.value;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: fishOpacity,
          child: Stack(
            children: [
              // 鰻魚 — 靠上層游動
              Positioned(
                top: 30 + math.sin(progress * math.pi) * 8,
                left: 20 + progress * 180,
                child: Transform.flip(
                  flipX: progress >= 0.5,
                  child: const Text('🐍', style: TextStyle(fontSize: 28)),
                ),
              ),

              // 烏魚 — 中間層游動（反向）
              Positioned(
                top: 70 + math.cos(progress * math.pi) * 6,
                right: 30 + progress * 150,
                child: Transform.flip(
                  flipX: progress < 0.5,
                  child: const Text('🐟', style: TextStyle(fontSize: 24)),
                ),
              ),

              // 小魚群 — 靠底層
              Positioned(
                top: 100 + math.sin(progress * math.pi * 2) * 5,
                left: 80 + progress * 100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: state == EcoState.thriving ? 0.8 : 0.3,
                  child: const Text('🐠', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCriticalOverlay() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        final blinkOpacity =
            0.15 + 0.15 * math.sin(_waveController.value * math.pi * 2);
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.dangerRed.withValues(alpha: blinkOpacity),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '⚠️',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '生態系統瀕臨崩潰！\n請減少高碳排消費',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
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

  Widget _buildFooterHint(EcoState state) {
    final (hint, color) = switch (state) {
      EcoState.thriving => (
          '🐟 鰻魚與烏魚在清澈水池中健康成長！繼續保持綠色消費 💚',
          AppTheme.primaryGreen,
        ),
      EcoState.warning => (
          '⚡ 水質開始混濁，魚群活力下降...試著選擇在地低碳海鮮吧',
          const Color(0xFFFFD54F),
        ),
      EcoState.critical => (
          '⚠️ 碳預算嚴重超標！虛擬生態池即將崩潰，立即行動！',
          AppTheme.dangerRed,
        ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        hint,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━ Custom Painters ━━━━━━━━━━━━━━━

class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color waveColor;
  final int waveCount;

  _WavePainter({
    required this.animationValue,
    required this.waveColor,
    this.waveCount = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < waveCount; i++) {
      final paint = Paint()
        ..color = waveColor.withValues(alpha: 0.08 + i * 0.04)
        ..style = PaintingStyle.fill;

      final path = Path();
      final yBase = 15.0 + i * 12.0;
      final phase = animationValue * 2 * math.pi + i * 0.8;

      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 1) {
        final y = yBase +
            math.sin((x / size.width) * 2 * math.pi + phase) * (4.0 + i * 2);
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _BubblePainter extends CustomPainter {
  final double animationValue;
  final Color bubbleColor;

  _BubblePainter({
    required this.animationValue,
    required this.bubbleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    final rng = math.Random(42); // 固定種子保持氣泡位置穩定
    for (int i = 0; i < 8; i++) {
      final baseX = rng.nextDouble() * size.width;
      final phase = (animationValue + i * 0.12) % 1.0;
      final y = size.height * (1.0 - phase);
      final radius = 2.0 + rng.nextDouble() * 3.0;
      final wobble = math.sin(phase * math.pi * 4 + i) * 4;

      canvas.drawCircle(
        Offset(baseX + wobble, y),
        radius * (0.5 + phase * 0.5),
        paint..color = bubbleColor.withValues(alpha: (1.0 - phase) * 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
