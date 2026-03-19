import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';
import '../../widgets/dashboard_card.dart';

class BranchPerformanceScreen extends ConsumerWidget {
  final String restaurantId;

  const BranchPerformanceScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(firestoreServiceProvider).getBranches(restaurantId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Branch Performance', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: branchesAsync,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final branches = snap.data ?? [];
          if (branches.isEmpty) {
            return const Center(child: Text("No branches found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: branches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final b = branches[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Text(b.branchName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(b.location, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: DashboardCard(title: "Orders Today", value: "--", icon: Icons.receipt, gradientColors: [Color(0xFF3B82F6), Color(0xFF60A5FA)])),
                        SizedBox(width: 16),
                        Expanded(child: DashboardCard(title: "Revenue", value: "--", icon: Icons.attach_money, gradientColors: [Color(0xFF10B981), Color(0xFF34D399)])),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
