import 'CartItem.dart';

class Customer {
  final String name;
  final List<CartItem> cart = [];

  Customer(this.name);
}
