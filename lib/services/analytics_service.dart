import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsService {
  final List<OrderModel> orders;

  AnalyticsService(this.orders);

  double get totalRevenueToday {
    final today = DateTime.now();
    return orders.where((o) => _isSameDay(o.timestamp, today) && o.orderStatus == 'Completed')
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  int get totalOrdersToday {
    final today = DateTime.now();
    return orders.where((o) => _isSameDay(o.timestamp, today)).length;
  }

  int get cancelledOrdersToday {
    final today = DateTime.now();
    return orders.where((o) => _isSameDay(o.timestamp, today) && o.orderStatus == 'Cancelled').length;
  }

  List<FlSpot> getWeeklyRevenueSpots() {
    // Generate spots for the last 7 days
    Map<int, double> dailyRevenue = {};
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      dailyRevenue[date.day] = 0;
    }

    for (var o in orders) {
      if (o.orderStatus == 'Completed' && now.difference(o.timestamp).inDays <= 7) {
        if (dailyRevenue.containsKey(o.timestamp.day)) {
          dailyRevenue[o.timestamp.day] = dailyRevenue[o.timestamp.day]! + o.totalAmount;
        }
      }
    }

    List<FlSpot> spots = [];
    int index = 0;
    dailyRevenue.forEach((day, revenue) {
      spots.add(FlSpot(index.toDouble(), revenue));
      index++;
    });

    return spots;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

final analyticsServiceProvider = Provider.family<AnalyticsService, List<OrderModel>>((ref, orders) {
  return AnalyticsService(orders);
});
