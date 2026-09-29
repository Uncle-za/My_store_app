import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = AppState.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),

        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text(
                        'Are you sure you want to remove all items?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              cart.clear();
                            });

                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_sweep),
            ),
        ],
      ),

      body: cart.items.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Add some products to your cart.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,

              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        // Product image
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(8),

                          child: Image.network(
                            item.product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Product details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '\$${item.product.price.toStringAsFixed(2)} each',
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cart.decreaseQuantity(
                                          item.product.id,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons
                                          .remove_circle_outline,
                                    ),
                                  ),

                                  Text(
                                    '${item.quantity}',
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cart.increaseQuantity(
                                          item.product.id,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons
                                          .add_circle_outline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Delete button
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  cart.removeProduct(
                                    item.product.id,
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),

                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom total
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                ),
              ],
            ),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Total Items',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      );

                      // Cart is cleared after a successful order.
                      if (mounted) setState(() {});
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
