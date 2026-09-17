import 'package:models/models.dart';

/// Aggregated response structure for profit and loss report queries.
typedef ProfitLossReportResponse = ({
  List<ProfitLossItem> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
  double totalCostPrice,
  double totalCollectedPrice,
  double totalProfit,
  double totalMarginPercentage,
});

/// Aggregated response structure for stock summary report queries.
typedef StockSummaryReportResponse = ({
  List<StockSummaryItem> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
  int totalOpeningStock,
  int totalIn,
  int totalOut,
  int totalWastage,
  int totalAdjustment,
  int totalClosingStock,
});
