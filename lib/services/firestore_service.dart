import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant_model.dart';
import '../models/order_model.dart';
import '../models/pos_device_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<RestaurantModel>> getRestaurants() {
    return _db.collection('restaurants').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => RestaurantModel.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<BranchModel>> getBranches(String? restaurantId) {
    Query query = _db.collection('branches');
    if (restaurantId != null) {
      query = query.where('restaurant_id', isEqualTo: restaurantId);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<OrderModel>> getRecentOrders(String? restaurantId) {
    Query query = _db.collection('orders').orderBy('timestamp', descending: true).limit(50);
    if (restaurantId != null) {
      query = query.where('restaurant_id', isEqualTo: restaurantId);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Stream<List<PosDeviceModel>> getPosDevices(String? restaurantId) {
    // Note: Since pos_devices doesn't have restaurant_id directly in the spec,
    // we would ideally query branches first or assume POS holds it. 
    // Implementing a universal stream for now.
    return _db.collection('pos_devices').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PosDeviceModel.fromJson(doc.data(), doc.id)).toList());
  }
}

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final recentOrdersProvider = StreamProvider.family<List<OrderModel>, String?>((ref, restaurantId) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getRecentOrders(restaurantId);
});

final posDevicesProvider = StreamProvider.family<List<PosDeviceModel>, String?>((ref, restaurantId) {
  return ref.watch(firestoreServiceProvider).getPosDevices(restaurantId);
});
