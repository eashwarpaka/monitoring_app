import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';

class PosMonitorScreen extends ConsumerWidget {
  final String? restaurantId; // null for Super Admin

  const PosMonitorScreen({super.key, this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posAsync = ref.watch(firestoreServiceProvider).getPosDevices(restaurantId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('POS Monitor', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: posAsync,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final devices = snap.data ?? [];
          if (devices.isEmpty) {
            return const Center(child: Text("No POS devices found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: devices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final d = devices[index];
              // Assuming lastActive is within 5 minutes for "Online"
              final isActive = DateTime.now().difference(d.lastActive).inMinutes < 5;
              
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.point_of_sale,
                      color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                  title: Text(d.deviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text("Branch: ${d.branchId}\nLast Active: ${d.lastActive.toLocal()}"),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? "ONLINE" : "OFFLINE",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
