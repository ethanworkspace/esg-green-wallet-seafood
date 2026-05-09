import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/quest_model.dart';
import '../../providers/quest_provider.dart';
import '../../providers/user_points_provider.dart';

/// ─────────────────────────────────────────────
/// 限時閃電任務橫向列表
/// ─────────────────────────────────────────────
class FlashQuestSection extends ConsumerWidget {
  const FlashQuestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questListProvider);
    // 訂閱 ticker 讓倒數每秒刷新
    ref.watch(questTickerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 標題列 ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFFFFD54F),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '閃電任務',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.dangerRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '限時',
                  style: TextStyle(
                    color: AppTheme.dangerRed,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${quests.where((q) => q.status == QuestStatus.available || q.status == QuestStatus.accepted).length} 個進行中',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // ── 橫向滑動任務卡片 ──
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: quests.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FlashQuestCard(quest: quests[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━ 單張任務卡片 ━━━━━━━━━━━━━━━━━━━━

class _FlashQuestCard extends ConsumerWidget {
  final Quest quest;
  const _FlashQuestCard({required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAvailable = quest.status == QuestStatus.available;
    final isAccepted = quest.status == QuestStatus.accepted;
    final isCompleted = quest.status == QuestStatus.completed;
    final isExpired = quest.status == QuestStatus.expired;

    // 根據狀態決定邊框漸層
    final borderGradient = _borderGradient();
    final bgColor = _bgColor();

    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [borderGradient.$1, borderGradient.$2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 頂部：Emoji + 倒數 ──
            Row(
              children: [
                Text(quest.emoji, style: const TextStyle(fontSize: 24)),
                const Spacer(),
                _CountdownChip(quest: quest),
              ],
            ),

            const SizedBox(height: 10),

            // ── 標題 ──
            Text(
              quest.title,
              style: TextStyle(
                color: isExpired ? Colors.white38 : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // ── 描述 ──
            Text(
              quest.description,
              style: TextStyle(
                color:
                    isExpired ? Colors.white24 : Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // ── 底部：獎勵 + 按鈕 ──
            Row(
              children: [
                // 獎勵點數
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Color(0xFFFFD54F), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '+${quest.rewardPoints}',
                        style: const TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 行動按鈕
                if (isAvailable)
                  _buildActionButton(
                    label: '接受',
                    color: AppTheme.primaryGreen,
                    onTap: () {
                      ref
                          .read(questListProvider.notifier)
                          .acceptQuest(quest.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ 已接受任務：${quest.title}'),
                          backgroundColor: const Color(0xFF1A3A2A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  )
                else if (isAccepted)
                  _buildActionButton(
                    label: '完成',
                    color: const Color(0xFFFFD54F),
                    onTap: () {
                      ref
                          .read(questListProvider.notifier)
                          .completeQuest(quest.id);
                      ref
                          .read(userPointsProvider.notifier)
                          .addPoints(quest.rewardPoints);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '🎉 任務完成！獲得 ${quest.rewardPoints} 碳點數'),
                          backgroundColor: const Color(0xFF1A3A2A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  )
                else if (isCompleted)
                  _buildStatusChip('已完成', AppTheme.primaryGreen)
                else
                  _buildStatusChip('已過期', Colors.white24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── 邊框漸層色 ──
  (Color, Color) _borderGradient() => switch (quest.status) {
        QuestStatus.available => (
            const Color(0xFFFFD54F),
            const Color(0xFFFF6D00),
          ),
        QuestStatus.accepted => (
            AppTheme.primaryGreen,
            AppTheme.accentCyan,
          ),
        QuestStatus.completed => (
            AppTheme.primaryGreen.withValues(alpha: 0.4),
            AppTheme.primaryGreen.withValues(alpha: 0.2),
          ),
        QuestStatus.expired => (
            Colors.white10,
            Colors.white10,
          ),
      };

  // ── 背景色 ──
  Color _bgColor() => switch (quest.status) {
        QuestStatus.available => const Color(0xFF1E1E2C),
        QuestStatus.accepted => const Color(0xFF162420),
        QuestStatus.completed => const Color(0xFF1A1A28),
        QuestStatus.expired => const Color(0xFF181818),
      };

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━ 倒數計時 Chip ━━━━━━━━━━━━━━━━━━━━

class _CountdownChip extends ConsumerWidget {
  final Quest quest;
  const _CountdownChip({required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 監聽 ticker 確保每秒刷新
    ref.watch(questTickerProvider);

    final remaining = quest.remaining;
    final isUrgent = remaining.inHours < 6 && !quest.isExpired;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent
            ? AppTheme.dangerRed.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUrgent
              ? AppTheme.dangerRed.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 12,
            color: isUrgent ? AppTheme.dangerRed : Colors.white54,
          ),
          const SizedBox(width: 4),
          Text(
            quest.countdownText,
            style: TextStyle(
              color: isUrgent ? AppTheme.dangerRed : Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
