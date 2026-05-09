import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 發票解析結果
class ReceiptParseResult {
  final String itemName;
  final double carbonFootprint;
  final bool isLowCarbon;

  const ReceiptParseResult({
    required this.itemName,
    required this.carbonFootprint,
    required this.isLowCarbon,
  });
}

/// 模擬 LLM API 解析發票品項
/// 回傳 AsyncValue of ReceiptParseResult (nullable)
final receiptParseProvider =
    StateNotifierProvider<ReceiptParseNotifier, AsyncValue<ReceiptParseResult?>>(
  (ref) => ReceiptParseNotifier(),
);

class ReceiptParseNotifier
    extends StateNotifier<AsyncValue<ReceiptParseResult?>> {
  ReceiptParseNotifier() : super(const AsyncData(null));

  Future<void> parse(String input) async {
    state = const AsyncLoading();

    // 模擬 1.5 秒網路延遲
    await Future.delayed(const Duration(milliseconds: 1500));

    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      state = AsyncError('請輸入發票品項', StackTrace.current);
      return;
    }

    // 關鍵字比對 — 模擬 LLM 解析
    if (trimmed.contains('鮭魚')) {
      state = const AsyncData(ReceiptParseResult(
        itemName: '進口挪威鮭魚 (空運)',
        carbonFootprint: 12.5,
        isLowCarbon: false,
      ));
    } else if (trimmed.contains('鰻魚')) {
      state = const AsyncData(ReceiptParseResult(
        itemName: '台灣在地鰻魚 (AI智慧監控)',
        carbonFootprint: 2.1,
        isLowCarbon: true,
      ));
    } else if (trimmed.contains('烏魚')) {
      state = const AsyncData(ReceiptParseResult(
        itemName: '台灣在地烏魚 (數據監控)',
        carbonFootprint: 2.8,
        isLowCarbon: true,
      ));
    } else if (trimmed.contains('鯰魚')) {
      state = const AsyncData(ReceiptParseResult(
        itemName: '進口越南鯰魚 (海運)',
        carbonFootprint: 4.5,
        isLowCarbon: false,
      ));
    } else if (trimmed.contains('花蟹') || trimmed.contains('螃蟹')) {
      state = const AsyncData(ReceiptParseResult(
        itemName: '台灣野生藍花蟹',
        carbonFootprint: 3.1,
        isLowCarbon: false,
      ));
    } else {
      // 無法辨識的品項 — 給一個預設中等碳排
      state = AsyncData(ReceiptParseResult(
        itemName: trimmed,
        carbonFootprint: 5.0,
        isLowCarbon: false,
      ));
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
