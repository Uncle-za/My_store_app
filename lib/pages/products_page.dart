import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/app_state.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> products = const [
    Product(
      id: '1',
      name: 'Running Shoes',
      description:
      'Comfortable running shoes for everyday use.',
      price: 80.00,
      imageUrl: 'https://picsum.photos/300/300?1',
    ),

    Product(
      id: '2',
      name: 'Smart Watch',
      description:
      'A modern smartwatch with many useful features.',
      price: 120.00,
      imageUrl: 'https://picsum.photos/300/300?2',
    ),

    Product(
      id: '3',
      name: 'Backpack',
      description:
      'Durable backpack for school and travel.',
      price: 45.00,
      imageUrl: 'https://picsum.photos/300/300?3',
    ),

    Product(
      id: '4',
      name: 'Headphones',
      description:
      'Wireless headphones with great sound.',
      price: 65.00,
      imageUrl: 'https://picsum.photos/300/300?4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),

        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );

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

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),

        itemCount: products.length,

        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],

            onProductAdded: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
