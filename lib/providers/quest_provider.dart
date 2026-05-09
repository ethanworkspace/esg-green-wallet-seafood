import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_model.dart';

// ─── Mock 限時任務清單 ───

List<Quest> _createMockQuests() {
  final now = DateTime.now();
  return [
    Quest(
      id: 'quest_eco_rescue',
      title: '拯救生態大作戰',
      description: '連續購買兩次在地 AI 鰻魚，拯救虛擬生態池！',
      rewardPoints: 100,
      deadline: now.add(const Duration(hours: 24)),
      emoji: '🐟',
    ),
    Quest(
      id: 'quest_low_carbon_logistics',
      title: '低碳物流挑戰',
      description: '選擇公路運輸的海產，減少物流碳排放',
      rewardPoints: 50,
      deadline: now.add(const Duration(hours: 12)),
      emoji: '🚛',
    ),
    Quest(
      id: 'quest_weekend_local',
      title: '週末在地海鮮計畫',
      description: '本週末購買任一台灣在地養殖海產，點數雙倍送！',
      rewardPoints: 80,
      deadline: now.add(const Duration(hours: 48)),
      emoji: '🎯',
    ),
  ];
}

// ─── Quest List StateNotifier ───

class QuestListNotifier extends StateNotifier<List<Quest>> {
  QuestListNotifier() : super(_createMockQuests());

  /// 接受任務
  void acceptQuest(String questId) {
    state = [
      for (final q in state)
        if (q.id == questId && q.status == QuestStatus.available)
          q.copyWith(status: QuestStatus.accepted)
        else
          q,
    ];
  }

  /// 完成任務
  void completeQuest(String questId) {
    state = [
      for (final q in state)
        if (q.id == questId && q.status == QuestStatus.accepted)
          q.copyWith(status: QuestStatus.completed)
        else
          q,
    ];
  }

  /// 刷新過期狀態
  void refreshExpired() {
    final now = DateTime.now();
    state = [
      for (final q in state)
        if (q.status != QuestStatus.completed &&
            q.status != QuestStatus.expired &&
            now.isAfter(q.deadline))
          q.copyWith(status: QuestStatus.expired)
        else
          q,
    ];
  }
}

final questListProvider =
    StateNotifierProvider<QuestListNotifier, List<Quest>>((ref) {
  return QuestListNotifier();
});

// ─── 倒數計時 Ticker（每秒觸發 rebuild）───

/// 這個 Provider 每秒發出一個新的 DateTime，
/// 讓監聽的 widget 自動重繪倒數計時器。
final questTickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final controller = StreamController<DateTime>();

  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    controller.add(DateTime.now());
    // 順便刷新過期狀態
    ref.read(questListProvider.notifier).refreshExpired();
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
