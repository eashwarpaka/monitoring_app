import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/order_list_widget.dart';
import 'pos_monitor_screen.dart';
import 'restaurants_screen.dart';
import '../analytics/sales_analytics_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const SuperAdminHomeView(),
      const PosMonitorScreen(),
      const SalesAnalyticsScreen(),
      const RestaurantsScreen(),
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
          indicatorColor: const Color(0xFF4F46E5).withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale), label: 'POS'),
            NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
            NavigationDestination(icon: Icon(Icons.store_mall_directory_outlined), selectedIcon: Icon(Icons.store_mall_directory), label: 'Stores'),
          ],
        ),
      ),
    );
  }
}

class SuperAdminHomeView extends ConsumerWidget {
  const SuperAdminHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(firestoreServiceProvider).getRestaurants();
    final allOrdersAsync = ref.watch(recentOrdersProvider(null));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text("Platform Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 24),
            allOrdersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (orders) {
                final todayRevenue = orders
                    .where((o) => o.timestamp.day == DateTime.now().day && o.orderStatus != 'cancelled')
                    .fold(0.0, (sum, o) => sum + o.totalAmount);
                final todayOrders = orders.where((o) => o.timestamp.day == DateTime.now().day).length;

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
                        StreamBuilder(
                          stream: restaurantsAsync,
                          builder: (context, restSnap) {
                            return DashboardCard(
                              title: "Total Restaurants",
                              value: "${restSnap.data?.length ?? 0}",
                              icon: Icons.store_mall_directory,
                              gradientColors: const [Color(0xFF8B5CF6), Color(0xFF3B82F6)], // Purple -> Blue
                            );
                          }
                        ),
                        const DashboardCard(
                          title: "Platform POS",
                          value: "Active", // simplified
                          icon: Icons.point_of_sale,
                          gradientColors: [Color(0xFF10B981), Color(0xFF14B8A6)], // Green -> Teal
                        ),
                        DashboardCard(
                          title: "Today's Orders",
                          value: "$todayOrders",
                          icon: Icons.receipt_long,
                          gradientColors: const [Color(0xFFF59E0B), Color(0xFFEAB308)], // Orange -> Yellow
                        ),
                        DashboardCard(
                          title: "Today's Revenue",
                          value: "₹${todayRevenue.toStringAsFixed(0)}",
                          icon: Icons.currency_rupee,
                          gradientColors: const [Color(0xFFEC4899), Color(0xFFF43F5E)], // Pink -> Rose
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    OrderListWidget(orders: orders),
                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
