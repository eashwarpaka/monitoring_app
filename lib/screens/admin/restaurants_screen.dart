import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';

class RestaurantsScreen extends ConsumerWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restsAsync = ref.watch(firestoreServiceProvider).getRestaurants();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('All Restaurants', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: restsAsync,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final rests = snap.data ?? [];
          if (rests.isEmpty) {
            return const Center(child: Text("No restaurants found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: rests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final r = rests[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF818CF8)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF4F46E5).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, color: Color(0xFF4F46E5)),
                  ),
                  title: Text(r.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text("ID: ${r.restaurantId}", style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
