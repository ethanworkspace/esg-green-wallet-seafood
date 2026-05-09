/// 折價券資料模型
class Coupon {
  final String id;
  final String title;
  final String description;
  final int requiredPoints;
  final bool isRedeemed;

  const Coupon({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredPoints,
    this.isRedeemed = false,
  });

  Coupon copyWith({bool? isRedeemed}) {
    return Coupon(
      id: id,
      title: title,
      description: description,
      requiredPoints: requiredPoints,
      isRedeemed: isRedeemed ?? this.isRedeemed,
    );
  }
}
