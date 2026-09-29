import 'cart_item.dart';
import 'product.dart';

class Cart {
  final List<CartItem> items = [];

  void addProduct(Product product) {
    final existingIndex = items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      items[existingIndex].quantity++;
    } else {
      items.add(
        CartItem(
          product: product,
          quantity: 1,
        ),
      );
    }
  }

  void removeProduct(String productId) {
    items.removeWhere(
          (item) => item.product.id == productId,
    );
  }

  void increaseQuantity(String productId) {
    final index = items.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index != -1) {
      items[index].quantity++;
    }
  }

  void decreaseQuantity(String productId) {
    final index = items.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
  }

  int get totalItems {
    return items.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  double get totalPrice {
    return items.fold(
      0,
          (sum, item) => sum + item.totalPrice,
    );
  }

  void clear() {
    items.clear();
  }
}
