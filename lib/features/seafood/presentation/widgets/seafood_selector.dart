import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/seafood_repository.dart';
import '../../domain/models/seafood_item.dart';

class SeafoodSelector extends ConsumerWidget {
  const SeafoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seafoodList = ref.watch(seafoodListProvider);
    final indexA = ref.watch(selectedSeafoodAProvider);
    final indexB = ref.watch(selectedSeafoodBProvider);

    return Column(
      children: [
        _buildDropdown(
          context: context,
          label: '海鮮 A',
          icon: Icons.looks_one_rounded,
          color: AppTheme.primaryGreen,
          items: seafoodList,
          selectedIndex: indexA,
          onChanged: (i) =>
              ref.read(selectedSeafoodAProvider.notifier).state = i,
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          context: context,
          label: '海鮮 B',
          icon: Icons.looks_two_rounded,
          color: AppTheme.accentCyan,
          items: seafoodList,
          selectedIndex: indexB,
          onChanged: (i) =>
              ref.read(selectedSeafoodBProvider.notifier).state = i,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required List<SeafoodItem> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedIndex,
                isExpanded: true,
                dropdownColor: AppTheme.cardDarkAlt,
                borderRadius: BorderRadius.circular(16),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: color.withValues(alpha: 0.6),
                ),
                items: List.generate(items.length, (i) {
                  return DropdownMenuItem(
                    value: i,
                    child: Text(
                      items[i].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
