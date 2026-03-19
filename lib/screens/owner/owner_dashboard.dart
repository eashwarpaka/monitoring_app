import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/sales_chart_widget.dart';
import '../../widgets/order_list_widget.dart';
import '../admin/pos_monitor_screen.dart';
import '../analytics/sales_analytics_screen.dart';
import 'branch_performance_screen.dart';

class OwnerDashboard extends StatefulWidget {
  final String restaurantId;
  const OwnerDashboard({super.key, required this.restaurantId});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      OwnerHomeView(restaurantId: widget.restaurantId),
      PosMonitorScreen(restaurantId: widget.restaurantId),
      SalesAnalyticsScreen(restaurantId: widget.restaurantId),
      BranchPerformanceScreen(restaurantId: widget.restaurantId),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF10B981).withValues(alpha: 0.2), // Green tint for owner
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale), label: 'POS'),
            NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Branches'),
          ],
        ),
      ),
    );
  }
}

class OwnerHomeView extends ConsumerWidget {
  final String restaurantId;
  const OwnerHomeView({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myOrdersAsync = ref.watch(recentOrdersProvider(restaurantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Restaurant Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Operations Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 24),
            myOrdersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (orders) {
                final todayRevenue = orders
                    .where((o) => o.timestamp.day == DateTime.now().day && o.orderStatus != 'cancelled')
                    .fold(0.0, (sum, o) => sum + o.totalAmount);
                final todayOrders = orders.where((o) => o.timestamp.day == DateTime.now().day).length;
                final cancelled = orders.where((o) => o.orderStatus == 'cancelled').length;

                return Column(
                  children: [
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      children: [
                        DashboardCard(
                          title: "Today's Revenue",
                          value: "₹${todayRevenue.toStringAsFixed(0)}",
                          icon: Icons.trending_up,
                          gradientColors: const [Color(0xFF4F46E5), Color(0xFF3B82F6)], // Indigo -> Blue
                        ),
                        DashboardCard(
                          title: "Orders Today",
                          value: "$todayOrders",
                          icon: Icons.list_alt,
                          gradientColors: const [Color(0xFFF59E0B), Color(0xFFFBBF24)], // Orange -> Amber
                        ),
                        DashboardCard(
                          title: "Cancelled",
                          value: "$cancelled",
                          icon: Icons.cancel_outlined,
                          gradientColors: const [Color(0xFFEF4444), Color(0xFFF43F5E)], // Red -> Rose
                        ),
                        const DashboardCard(
                          title: "Active POS",
                          value: "Online", 
                          icon: Icons.point_of_sale,
                          gradientColors: [Color(0xFF10B981), Color(0xFF34D399)], // Green
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    OrderListWidget(orders: orders),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
