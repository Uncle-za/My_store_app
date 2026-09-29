import 'package:flutter/material.dart';
import '../models/order.dart';

/// Vertical step tracker showing where an order is in its lifecycle.
class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusTimeline({super.key, required this.status});

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return const ListTile(
        leading: Icon(Icons.cancel, color: Colors.red),
        title: Text('Order cancelled'),
        contentPadding: EdgeInsets.zero,
      );
    }

    final current = _steps.indexOf(status);

    return Column(
      children: [
        for (var i = 0; i < _steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    i <= current
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: i <= current ? Colors.green : Colors.grey,
                  ),
                  if (i != _steps.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      color: i < current ? Colors.green : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _steps[i].label,
                  style: TextStyle(
                    fontWeight:
                        i == current ? FontWeight.bold : FontWeight.normal,
                    color: i <= current ? null : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Small coloured chip for lists.
class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.shipped:
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
