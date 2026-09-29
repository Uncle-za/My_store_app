import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'order_confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String _payment = 'Cash on Delivery';
  bool _placing = false;

  static const _paymentMethods = [
    'Cash on Delivery',
    'Credit / Debit Card',
    'Mobile Money',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _review() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = AppState.cart;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm your order'),
        content: Text(
          'Place an order for ${cart.totalItems} item(s) totalling '
          '\$${cart.totalPrice.toStringAsFixed(2)}?\n\n'
          'Deliver to: ${_addressController.text.trim()}\n'
          'Payment: $_payment',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );

    if (confirmed == true) await _placeOrder();
  }

  Future<void> _placeOrder() async {
    setState(() => _placing = true);

    final order = await AppState.orders.placeOrder(
      cart: AppState.cart,
      customerEmail: AppState.auth.email ?? '',
      fullName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      paymentMethod: _payment,
    );

    AppState.cart.clear();

    if (!mounted) return;

    // Replace the checkout page so "back" doesn't return to an empty checkout.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(orderId: order.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = AppState.cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: AbsorbPointer(
        absorbing: _placing,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final item in cart.items)
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
                              '\$${cart.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Delivery Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Delivery address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().length < 5)
                      ? 'Please enter a delivery address'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                    return digits.length < 7
                        ? 'Please enter a valid phone number'
                        : null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    for (final m in _paymentMethods)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          _payment == m
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: _payment == m
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        title: Text(m),
                        onTap: () => setState(() => _payment = m),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _placing ? null : _review,
                    child: _placing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Place Order  •  \$${cart.totalPrice.toStringAsFixed(2)}',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
