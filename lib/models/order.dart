import 'cart_item.dart';

enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// The next step in the normal flow, or null if finished/cancelled.
  OrderStatus? get next {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.confirmed;
      case OrderStatus.confirmed:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.shipped;
      case OrderStatus.shipped:
        return OrderStatus.delivered;
      default:
        return null;
    }
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String customerEmail;
  final String fullName;
  final String address;
  final String phone;
  final String paymentMethod;
  final DateTime createdAt;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.customerEmail,
    required this.fullName,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
}
