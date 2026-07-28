import 'cart_item.dart';

class OrderModel {
  final String id;
  final String date;
  final List<CartItem> items;
  final double total;
  final bool isDelivering;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.isDelivering = true,
  });
}
