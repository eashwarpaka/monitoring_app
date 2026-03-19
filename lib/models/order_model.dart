class OrderModel {
  final String orderId;
  final String restaurantId;
  final String branchId;
  final String posId;
  final double totalAmount;
  final String orderStatus;
  final DateTime timestamp;
  final String items; // Stored as json string in original pos app

  OrderModel({
    required this.orderId,
    required this.restaurantId,
    required this.branchId,
    required this.posId,
    required this.totalAmount,
    required this.orderStatus,
    required this.timestamp,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      orderId: id,
      restaurantId: json['restaurant_id'] ?? '',
      branchId: json['branch_id'] ?? '',
      posId: json['pos_id'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      orderStatus: json['order_status'] ?? 'unknown',
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']) 
          : DateTime.now(),
      items: json['items'] ?? '[]',
    );
  }
}
