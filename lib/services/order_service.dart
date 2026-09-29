import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService extends ChangeNotifier {
  final List<Order> _orders = [];
  final Map<String, Timer> _timers = {};

  List<Order> get orders => List.unmodifiable(_orders.reversed);

  Order? byId(String id) {
    for (final o in _orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  /// Turns the current cart into an order (snapshotting the items).
  Future<Order> placeOrder({
    required Cart cart,
    required String customerEmail,
    required String fullName,
    required String address,
    required String phone,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // fake processing

    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      items: cart.items
          .map((i) => CartItem(product: i.product, quantity: i.quantity))
          .toList(),
      total: cart.totalPrice,
      customerEmail: customerEmail,
      fullName: fullName,
      address: address,
      phone: phone,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
    );

    _orders.add(order);
    notifyListeners();
    _simulateProgress(order);
    return order;
  }

  void cancelOrder(String id) {
    final order = byId(id);
    if (order == null) return;
    if (order.status == OrderStatus.shipped ||
        order.status == OrderStatus.delivered) {
      return; // too late to cancel
    }
    _timers.remove(id)?.cancel();
    order.status = OrderStatus.cancelled;
    notifyListeners();
  }

  /// Demo only: moves the order through the statuses over time.
  /// In a real app the status would come from your backend.
  void _simulateProgress(Order order) {
    _timers[order.id] = Timer.periodic(const Duration(seconds: 8), (t) {
      final next = order.status.next;
      if (next == null || order.status == OrderStatus.cancelled) {
        t.cancel();
        _timers.remove(order.id);
        return;
      }
      order.status = next;
      notifyListeners();
    });
  }
}
