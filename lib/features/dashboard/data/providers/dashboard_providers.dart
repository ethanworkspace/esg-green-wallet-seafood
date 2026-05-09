import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/receipt_model.dart';
import '../../../../services/invoice_service.dart';

/// 模擬交易紀錄
class TransactionRecord {
  final String title;
  final String subtitle;
  final double co2;
  final IconData icon;
  final Color iconColor;
  final bool hasLowCarbonAlt; // 是否有低碳替代品

  const TransactionRecord({
    required this.title,
    required this.subtitle,
    required this.co2,
    required this.icon,
    required this.iconColor,
    this.hasLowCarbonAlt = false,
  });
}

// ─── 初始假資料 ───

const List<TransactionRecord> _initialTransactions = [
  TransactionRecord(
    title: '超市購物',
    subtitle: '全聯福利中心 · 今天',
    co2: 3.2,
    icon: Icons.shopping_cart_outlined,
    iconColor: Color(0xFF42A5F5),
  ),
  TransactionRecord(
    title: '午餐 — 進口鮭魚定食',
    subtitle: '王品牛排 · 昨天',
    co2: 12.5,
    icon: Icons.restaurant_outlined,
    iconColor: Color(0xFFFF7043),
    hasLowCarbonAlt: true,
  ),
  TransactionRecord(
    title: '通勤 — 捷運',
    subtitle: '台北捷運 · 昨天',
    co2: 0.8,
    icon: Icons.train_outlined,
    iconColor: Color(0xFF00C853),
  ),
  TransactionRecord(
    title: '海鮮 — 進口鮭魚',
    subtitle: '上引水產 · 3 天前',
    co2: 5.4,
    icon: Icons.set_meal_outlined,
    iconColor: Color(0xFF26C6DA),
    hasLowCarbonAlt: true,
  ),
  TransactionRecord(
    title: '外送餐點',
    subtitle: 'Uber Eats · 4 天前',
    co2: 7.1,
    icon: Icons.delivery_dining_outlined,
    iconColor: Color(0xFFAB47BC),
  ),
];

// ─── 起始碳預算 ───

const double initialBudget = 50.0;

// ─── 可變交易清單 ───

class TransactionsNotifier extends StateNotifier<List<TransactionRecord>> {
  TransactionsNotifier() : super([..._initialTransactions]);

  /// 在列表最前方插入新交易
  void addTransaction(TransactionRecord tx) {
    state = [tx, ...state];
  }

  /// 從 Receipt 批次匯入所有品項
  void importReceipt(Receipt receipt) {
    final now = DateTime.now();
    final dateStr = '${now.month}/${now.day} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    final newTxs = receipt.items.map((item) {
      return TransactionRecord(
        title: item.name,
        subtitle: '${receipt.storeName} · $dateStr',
        co2: item.estimatedCO2,
        icon: item.estimatedCO2 > 5.0
            ? Icons.warning_amber_rounded
            : Icons.eco_outlined,
        iconColor: item.estimatedCO2 > 5.0
            ? const Color(0xFFFF7043)
            : const Color(0xFF00C853),
        hasLowCarbonAlt: item.hasLowCarbonAlt,
      );
    }).toList();

    state = [...newTxs, ...state];
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionRecord>>(
  (ref) => TransactionsNotifier(),
);

// ─── 碳排計算（自動跟隨交易清單變動）───

/// 已使用碳排（從交易累加）
final usedCarbonProvider = Provider<double>((ref) {
  final txs = ref.watch(transactionsProvider);
  return txs.fold(0.0, (sum, tx) => sum + tx.co2);
});

/// 剩餘碳預算
final remainingCarbonProvider = Provider<double>((ref) {
  final used = ref.watch(usedCarbonProvider);
  return (initialBudget - used).clamp(0.0, initialBudget);
});

// ─── 發票匯入服務 ───

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  return InvoiceService();
});

/// 發票匯入狀態
enum InvoiceImportStatus { idle, loading, success, error }

class InvoiceImportState {
  final InvoiceImportStatus status;
  final Receipt? lastReceipt;
  final String? errorMessage;

  const InvoiceImportState({
    this.status = InvoiceImportStatus.idle,
    this.lastReceipt,
    this.errorMessage,
  });

  InvoiceImportState copyWith({
    InvoiceImportStatus? status,
    Receipt? lastReceipt,
    String? errorMessage,
  }) {
    return InvoiceImportState(
      status: status ?? this.status,
      lastReceipt: lastReceipt ?? this.lastReceipt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class InvoiceImportNotifier extends StateNotifier<InvoiceImportState> {
  final Ref _ref;

  InvoiceImportNotifier(this._ref) : super(const InvoiceImportState());

  /// 執行發票匯入：fetch → 轉成交易 → 更新碳預算
  Future<void> importInvoices() async {
    state = state.copyWith(status: InvoiceImportStatus.loading);

    try {
      final service = _ref.read(invoiceServiceProvider);
      final receipt = await service.fetchLatestInvoices();

      // 匯入交易紀錄 → usedCarbonProvider 自動更新
      // → remainingCarbonProvider 自動更新
      // → eco_state_provider 自動更新
      _ref.read(transactionsProvider.notifier).importReceipt(receipt);

      state = state.copyWith(
        status: InvoiceImportStatus.success,
        lastReceipt: receipt,
      );
    } catch (e) {
      state = state.copyWith(
        status: InvoiceImportStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const InvoiceImportState();
  }
}

final invoiceImportProvider =
    StateNotifierProvider<InvoiceImportNotifier, InvoiceImportState>(
  (ref) => InvoiceImportNotifier(ref),
);
