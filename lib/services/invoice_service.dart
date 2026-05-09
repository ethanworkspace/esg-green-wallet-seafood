import '../models/receipt_model.dart';

/// 模擬雲端發票 API 服務
class InvoiceService {
  /// 模擬從財政部電子發票平台取得最新發票
  /// 延遲 1.5 秒模擬網路請求
  Future<Receipt> fetchLatestInvoices() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    return Receipt(
      id: 'INV-2026-05-10-001',
      date: DateTime.now(),
      storeName: '台灣生鮮超市',
      items: const [
        ReceiptItem(
          name: '在地 AI 智慧養殖鰻魚',
          amount: 350,
          estimatedCO2: 2.1,
          hasLowCarbonAlt: false, // 已是低碳選項
        ),
        ReceiptItem(
          name: '進口挪威空運鮭魚',
          amount: 500,
          estimatedCO2: 12.5,
          hasLowCarbonAlt: true, // 有低碳替代品
        ),
      ],
    );
  }
}
