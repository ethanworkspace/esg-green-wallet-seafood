import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/seafood_item.dart';

/// Mock 海鮮資料 Provider
final seafoodListProvider = Provider<List<SeafoodItem>>((ref) {
  return const [
    SeafoodItem(
      name: '進口挪威鮭魚 (空運)',
      category: '養殖鮭魚',
      origin: '挪威',
      productionMethod: '傳統養殖',
      transportMode: '空運',
      carbonFootprint: 12.5,
    ),
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
});

/// 選取的海鮮 A index
final selectedSeafoodAProvider = StateProvider<int>((ref) => 0);

/// 選取的海鮮 B index
final selectedSeafoodBProvider = StateProvider<int>((ref) => 1);
