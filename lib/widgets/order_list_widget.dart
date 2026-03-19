import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrderListWidget extends StatefulWidget {
  final List<OrderModel> orders;

  const OrderListWidget({super.key, required this.orders});

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  String _filter = 'today'; // could be 'today', '7days', '30days'

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final filteredOrders = widget.orders.where((o) {
      if (_filter == 'today') {
        return o.timestamp.day == now.day &&
               o.timestamp.month == now.month &&
               o.timestamp.year == now.year;
      }
      if (_filter == '7days') {
        return now.difference(o.timestamp).inDays <= 7;
      }
      if (_filter == '30days') {
        return now.difference(o.timestamp).inDays <= 30;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Orders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _filter,
              items: const [
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: '7days', child: Text('Last 7 Days')),
                DropdownMenuItem(value: '30days', child: Text('Last 30 Days')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _filter = val);
              },
            )
          ],
        ),
        const SizedBox(height: 12),
        filteredOrders.isEmpty
            ? const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No orders found."),
              ))
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  final isCompleted = order.orderStatus.toLowerCase() == 'completed';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${order.orderId}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Branch: ${order.branchId}",
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${order.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isCompleted ? Colors.green : Colors.red).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.orderStatus.toUpperCase(),
                                style: TextStyle(
                                  color: isCompleted ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}
