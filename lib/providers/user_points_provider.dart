import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coupon_model.dart';

// ─── 使用者點數 ───

final userPointsProvider =
    StateNotifierProvider<UserPointsNotifier, int>(
  (ref) => UserPointsNotifier(),
);

class UserPointsNotifier extends StateNotifier<int> {
  UserPointsNotifier() : super(500); // 初始 500 點

  /// 兌換折價券：扣點 + 更新 coupon 狀態
  /// 成功回傳 true，點數不足拋出 StateError
  void redeemCoupon(Coupon coupon) {
    if (coupon.isRedeemed) {
      throw StateError('此折價券已兌換');
    }
    if (state < coupon.requiredPoints) {
      throw StateError(
        '點數不足！需要 ${coupon.requiredPoints} 點，目前只有 $state 點',
      );
    }
    state = state - coupon.requiredPoints;
  }

  /// 增加點數（減碳獎勵等）
  void addPoints(int points) {
    state = state + points;
  }
}

// ─── 折價券清單 ───

final couponListProvider =
    StateNotifierProvider<CouponListNotifier, List<Coupon>>(
  (ref) => CouponListNotifier(),
);

class CouponListNotifier extends StateNotifier<List<Coupon>> {
  CouponListNotifier()
      : super(const [
          Coupon(
            id: 'coupon_eel_80',
            title: '在地 AI 鰻魚 8 折券',
            description: '適用於台灣在地 AI 智慧監控養殖鰻魚，結帳享 8 折優惠',
            requiredPoints: 300,
          ),
          Coupon(
            id: 'coupon_mullet_50',
            title: '低碳數據烏魚 50 元折抵',
            description: '購買台灣在地數據監控養殖烏魚，現折 50 元',
            requiredPoints: 150,
          ),
          Coupon(
            id: 'coupon_free_shipping',
            title: '友善環境海鮮免運券',
            description: '全站友善環境海鮮商品訂單享免運費',
            requiredPoints: 100,
          ),
        ]);

  /// 標記某張折價券為已兌換
  void markRedeemed(String couponId) {
    state = [
      for (final c in state)
        if (c.id == couponId) c.copyWith(isRedeemed: true) else c,
    ];
  }
}

// ─── 整合兌換動作 ───

/// 呼叫此 provider 來執行兌換，同時扣點 + 更新 coupon 狀態
/// 回傳 null 代表成功，回傳 String 代表錯誤訊息
final redeemCouponProvider =
    Provider.family<String?, String>((ref, couponId) {
  // 這個 provider 僅用於依賴注入，實際兌換邏輯在下面的函數
  return null;
});

/// 執行兌換的工具函數（從 widget 層呼叫）
String? executeRedeem(WidgetRef ref, String couponId) {
  final coupons = ref.read(couponListProvider);
  final coupon = coupons.firstWhere(
    (c) => c.id == couponId,
    orElse: () => throw StateError('找不到折價券'),
  );

  try {
    ref.read(userPointsProvider.notifier).redeemCoupon(coupon);
    ref.read(couponListProvider.notifier).markRedeemed(couponId);
    return null; // 成功
  } on StateError catch (e) {
    return e.message; // 回傳錯誤訊息
  }
}
