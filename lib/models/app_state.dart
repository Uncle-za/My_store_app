import 'cart.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';

class AppState {
  static final Cart cart = Cart();
  static final AuthService auth = AuthService();
  static final OrderService orders = OrderService();
}
