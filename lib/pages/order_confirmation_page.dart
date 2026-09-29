import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/order.dart';
import '../widgets/order_status_timeline.dart';
import 'orders_page.dart';

/// Shown right after checkout AND when opening an order from "My Orders".
/// It listens to [OrderService] so the status updates live.
class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  /// true = just placed (shows the success banner and "Continue Shopping").
  final bool justPlaced;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    this.justPlaced = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.orders,
      builder: (context, _) {
        final order = AppState.orders.byId(orderId);

        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order')),
            body: const Center(child: Text('Order not found')),
          );
        }

        final canCancel = order.status == OrderStatus.pending ||
            order.status == OrderStatus.confirmed ||
            order.status == OrderStatus.processing;

        return Scaffold(
          appBar: AppBar(
            title: Text(justPlaced ? 'Order Confirmed' : 'Order Details'),
            automaticallyImplyLeading: !justPlaced,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (justPlaced && order.status != OrderStatus.cancelled)
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 80),
                        const SizedBox(height: 12),
                        const Text(
                          'Thank you for your order!',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A confirmation was sent to ${order.customerEmail}',
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                Card(
                  child: ListTile(
                    title: Text(
                      order.id,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Placed ${_formatDate(order.createdAt)}',
                    ),
                    trailing: OrderStatusChip(status: order.status),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Order Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                OrderStatusTimeline(status: order.status),
                const SizedBox(height: 24),
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final item in order.items)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity}',
                                  ),
                                ),
                                Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delivery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: Text(order.fullName),
                    subtitle: Text(
                      '${order.address}\n${order.phone}\nPayment: ${order.paymentMethod}',
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: 24),
                if (canCancel)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () => _confirmCancel(context, order),
                      child: const Text('Cancel Order'),
                    ),
                  ),
                if (justPlaced) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrdersPage()),
                        );
                      },
                      child: const Text('View My Orders'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmCancel(BuildContext context, Order order) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel order?'),
        content: Text('Are you sure you want to cancel ${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, cancel',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (yes == true) AppState.orders.cancelOrder(order.id);
  }

  static String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
