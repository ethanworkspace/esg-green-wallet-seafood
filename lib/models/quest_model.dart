/// 限時綠色閃電任務資料模型
class Quest {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final DateTime deadline;
  final String emoji;
  final QuestStatus status;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.deadline,
    this.emoji = '⚡',
    this.status = QuestStatus.available,
  });

  Quest copyWith({QuestStatus? status}) {
    return Quest(
      id: id,
      title: title,
      description: description,
      rewardPoints: rewardPoints,
      deadline: deadline,
      emoji: emoji,
      status: status ?? this.status,
    );
  }

  /// 距離截止時間的剩餘 Duration
  Duration get remaining {
    final diff = deadline.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  /// 是否已過期
  bool get isExpired => DateTime.now().isAfter(deadline);

  /// 格式化倒數 HH:MM:SS
  String get countdownText {
    final r = remaining;
    if (r == Duration.zero) return '已過期';
    final h = r.inHours.toString().padLeft(2, '0');
    final m = (r.inMinutes % 60).toString().padLeft(2, '0');
    final s = (r.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

enum QuestStatus {
  /// 尚未接受
  available,

  /// 已接受、進行中
  accepted,

  /// 已完成
  completed,

  /// 已過期
  expired,
}
