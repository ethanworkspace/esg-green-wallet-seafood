import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/coupon_model.dart';
import '../../../../providers/user_points_provider.dart';

class RewardScreen extends ConsumerWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(userPointsProvider);
    final coupons = ref.watch(couponListProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 標題 ──
            Text(
              '兌換中心',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              '用你的碳點數兌換專屬優惠',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white38,
                  ),
            ),

            const SizedBox(height: 24),

            // ── Hero 點數卡 ──
            _PointsHeroCard(points: points),

            const SizedBox(height: 28),

            // ── 折價券區標題 ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD600).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.confirmation_num_outlined,
                    color: Color(0xFFFFD600),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '可兌換折價券',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${coupons.where((c) => !c.isRedeemed).length} 張可用',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── 折價券列表 ──
            ...coupons.map((coupon) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CouponCard(coupon: coupon, currentPoints: points),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── 點數 Hero 卡片 ───

class _PointsHeroCard extends StatelessWidget {
  final int points;
  const _PointsHeroCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A40), Color(0xFF2D1B69), Color(0xFF1A1A40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFD600).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD600).withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD600).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFFFFD600),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '我的碳點數',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Carbon Points',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco, color: AppTheme.primaryGreen, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'ESG',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$points',
                style: const TextStyle(
                  color: Color(0xFFFFD600),
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8, left: 6),
                child: Text(
                  '點',
                  style: TextStyle(
                    color: Color(0xFFFFD600),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '每減少 1 kg CO₂e 碳排可獲得 10 點',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
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

// ─── 折價券卡片 ───

class _CouponCard extends ConsumerWidget {
  final Coupon coupon;
  final int currentPoints;

  const _CouponCard({required this.coupon, required this.currentPoints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRedeem = !coupon.isRedeemed && currentPoints >= coupon.requiredPoints;
    final isRedeemed = coupon.isRedeemed;

    // 選 icon
    IconData couponIcon;
    Color accentColor;
    if (coupon.id.contains('eel')) {
      couponIcon = Icons.smart_toy_outlined;
      accentColor = AppTheme.primaryGreen;
    } else if (coupon.id.contains('mullet')) {
      couponIcon = Icons.insights_outlined;
      accentColor = const Color(0xFF26C6DA);
    } else {
      couponIcon = Icons.local_shipping_outlined;
      accentColor = const Color(0xFFAB47BC);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRedeemed
              ? Colors.white.withValues(alpha: 0.05)
              : canRedeem
                  ? accentColor.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isRedeemed
                      ? Colors.white.withValues(alpha: 0.05)
                      : accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  couponIcon,
                  color: isRedeemed
                      ? Colors.white24
                      : accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // 標題 + 說明
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.title,
                      style: TextStyle(
                        color: isRedeemed ? Colors.white30 : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration:
                            isRedeemed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon.description,
                      style: TextStyle(
                        color: isRedeemed
                            ? Colors.white12
                            : Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 底部：點數 + 按鈕
          Row(
            children: [
              // 所需點數
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isRedeemed
                      ? Colors.white.withValues(alpha: 0.03)
                      : const Color(0xFFFFD600).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 14,
                      color: isRedeemed
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFFFD600),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${coupon.requiredPoints} 點',
                      style: TextStyle(
                        color: isRedeemed
                            ? Colors.white.withValues(alpha: 0.2)
                            : const Color(0xFFFFD600),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 兌換按鈕
              if (isRedeemed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white24, size: 16),
                      SizedBox(width: 6),
                      Text(
                        '已兌換',
                        style: TextStyle(
                          color: Colors.white24,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              else if (canRedeem)
                FilledButton.icon(
                  onPressed: () => _confirmRedeem(context, ref),
                  icon: const Icon(Icons.redeem, size: 16),
                  label: const Text('立即兌換'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '點數不足',
                    style: TextStyle(
                      color: Colors.white24,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRedeem(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        title: const Text(
          '確認兌換',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coupon.title,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFFFFD600),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '將扣除 ${coupon.requiredPoints} 點',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '剩餘：${currentPoints - coupon.requiredPoints} 點',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final error = executeRedeem(ref, coupon.id);
              if (error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          '兌換成功！已扣除 ${coupon.requiredPoints} 點',
                        ),
                      ],
                    ),
                    backgroundColor: AppTheme.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(error),
                      ],
                    ),
                    backgroundColor: AppTheme.dangerRed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('確認兌換'),
          ),
        ],
      ),
    );
  }
}
