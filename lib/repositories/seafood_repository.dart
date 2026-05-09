import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/seafood_item.dart';

/// 模擬海鮮資料庫
const List<SeafoodItem> mockSeafoodDatabase = [
  SeafoodItem(
    name: '台灣在地鰻魚 (AI智慧監控)',
    category: '養殖鰻魚',
    origin: '台灣',
    productionMethod: 'AI智慧監控養殖',
    transportMode: '公路',
    carbonFootprint: 2.1,
  ),
  SeafoodItem(
    name: '台灣在地烏魚 (數據監控)',
    category: '養殖烏魚',
    origin: '台灣',
    productionMethod: '數據驅動養殖',
    transportMode: '公路',
    carbonFootprint: 2.8,
  ),
  SeafoodItem(
    name: '進口挪威鮭魚 (空運)',
    category: '養殖鮭魚',
    origin: '挪威',
    productionMethod: '傳統養殖',
    transportMode: '空運',
    carbonFootprint: 12.5,
  ),
  SeafoodItem(
    name: '進口越南鯰魚 (海運)',
    category: '養殖鯰魚',
    origin: '越南',
    productionMethod: '傳統養殖',
    transportMode: '海運',
    carbonFootprint: 4.5,
  ),
  SeafoodItem(
    name: '台灣野生藍花蟹',
    category: '野生花蟹',
    origin: '台灣',
    productionMethod: '野生捕撈',
    transportMode: '公路',
    carbonFootprint: 3.1,
  ),
];

// ─── Riverpod Providers ───

/// 海鮮清單 Provider
final seafoodListProvider = Provider<List<SeafoodItem>>((ref) {
  return mockSeafoodDatabase;
});

/// 選取的海鮮 A index
final selectedSeafoodAProvider = StateProvider<int>((ref) => 0);

/// 選取的海鮮 B index
final selectedSeafoodBProvider = StateProvider<int>((ref) => 2);

/// 減碳計算結果 Provider（自動根據選取更新）
final carbonReductionProvider = Provider<CarbonReductionResult>((ref) {
  final list = ref.watch(seafoodListProvider);
  final a = ref.watch(selectedSeafoodAProvider);
  final b = ref.watch(selectedSeafoodBProvider);
  return calculateCarbonReduction(
    chosen: list[a],
    compared: list[b],
  );
});
