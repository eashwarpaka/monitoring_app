import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';
import '../../models/order_model.dart';
import '../../widgets/dashboard_card.dart';

class SalesAnalyticsScreen extends ConsumerWidget {
  final String? restaurantId; // null means super admin

  const SalesAnalyticsScreen({super.key, this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(recentOrdersProvider(restaurantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (orders) {
          final completedOrders = orders.where((o) => o.orderStatus.toLowerCase() == 'completed').length;
          final cancelledOrders = orders.where((o) => o.orderStatus.toLowerCase() == 'cancelled').length;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Status Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFF22C55E),
                                value: completedOrders.toDouble(),
                                title: '$completedOrders',
                                radius: 50,
                                titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFEF4444),
                                value: cancelledOrders.toDouble(),
                                title: '$cancelledOrders',
                                radius: 50,
                                titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegend(const Color(0xFF22C55E), "Completed"),
                          const SizedBox(height: 12),
                          _buildLegend(const Color(0xFFEF4444), "Cancelled"),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text("Weekly Revenue Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Incorporate the original line chart widget here or build a new one
                // Since there is a sales_chart_widget, we can re-use it.
                // Normally we'd calculate daily revenue from orders list. Using a simple mock array for visual requirements.
                _buildBarChart(orders),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBarChart(List<OrderModel> orders) {
    // Basic aggregation by day
    final now = DateTime.now();
    List<double> dailyTotals = List.filled(7, 0.0);
    
    for (var o in orders) {
      if (o.orderStatus == 'completed') {
        final diff = now.difference(o.timestamp).inDays;
        if (diff >= 0 && diff < 7) {
          dailyTotals[6 - diff] += o.totalAmount;
        }
      }
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: dailyTotals.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF818CF8)]),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
