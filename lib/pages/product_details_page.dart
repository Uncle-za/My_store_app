import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/app_state.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),

        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );

              // Refresh badge when returning from cart
              setState(() {});
            },
            icon: Badge(
              label: Text(
                '${AppState.cart.totalItems}',
              ),
              child: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Container(
                    height: 300,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Product name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Product price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Product description
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Add to cart button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  // Add product to cart
                  AppState.cart.addProduct(product);

                  // IMPORTANT:
                  // Rebuild the page so the cart badge updates
                  setState(() {});

                  // Show confirmation
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} added to cart',
                        ),
                        duration: const Duration(
                          seconds: 3,
                        ),

                        action: SnackBarAction(
                          label: 'GO TO CART',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const CartPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                },

                icon: const Icon(
                  Icons.shopping_cart,
                ),

                label: const Text(
                  'Add to Cart',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
