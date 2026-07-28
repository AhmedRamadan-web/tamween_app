import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/app_language.dart';
import '../data/mock_data.dart';
import '../data/models/cart_item.dart';
import '../data/models/order_model.dart';
import '../data/models/product.dart';
import '../widgets/payment_gateway_sheet.dart';
import 'login_screen.dart';
import 'tabs/cart_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/store_tab.dart';

// ═══════════════════════════════════════════
//  MAIN NAVIGATION SCREEN
// ═══════════════════════════════════════════
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Tab index: 0=Home | 1=Orders | 2=Cart | 3=Store | 4=Profile
  int _idx = 0;

  final List<CartItem> _cart = [];
  final List<OrderModel> _orders = [
    OrderModel(
      id: '#TM-4821',
      date: '25 يوليو 2026',
      items: [CartItem(product: kProducts[1], quantity: 1)],
      total: 207.00,
      isDelivering: false,
    ),
  ];
  final Set<int> _favorites = {1, 2};

  // ── Cart helpers ──
  void _addMultipleToCart(Product p, int qty) {
    setState(() {
      final i = _cart.indexWhere((c) => c.product.id == p.id);
      if (i >= 0) {
        _cart[i].quantity += qty;
      } else {
        _cart.add(CartItem(product: p, quantity: qty));
      }
    });
    _snack('تم إضافة $qty من ${p.name} للسلة ✓');
  }

  void _setQty(int productId, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.removeWhere((c) => c.product.id == productId);
      } else {
        final i = _cart.indexWhere((c) => c.product.id == productId);
        if (i >= 0) _cart[i].quantity = qty;
      }
    });
  }

  void _clearCart() => setState(() => _cart.clear());

  int get _cartCount => _cart.fold(0, (s, c) => s + c.quantity);

  void _checkout(double total) {
    if (_cart.isEmpty) return;
    _showPaymentGatewaySheet(total);
  }

  void _showPaymentGatewaySheet(double total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaymentGatewaySheet(
        total: total,
        onPaymentSuccess: () {
          final oid = '#TM-${1000 + DateTime.now().millisecondsSinceEpoch % 9000}';
          setState(() {
            _orders.insert(
              0,
              OrderModel(
                id: oid,
                date: 'اليوم',
                items: List.from(_cart),
                total: total,
                isDelivering: true,
              ),
            );
            _cart.clear();
            _idx = 1; // go to Orders tab
          });
          Navigator.pop(ctx); // close payment sheet
          _showSuccessSheet(oid);
        },
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.right),
        backgroundColor: kPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تسجيل الخروج بنجاح 👋', textAlign: TextAlign.right),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  void _showSuccessSheet(String oid) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.instance.textDirection,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50, height: 5,
                decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 24),
              Container(
                width: 90, height: 90,
                decoration: const BoxDecoration(color: kPrimaryBg, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: kPrimary, size: 52),
              ),
              const SizedBox(height: 20),
              const Text(
                'تم إرسال طلبك بنجاح! 🎉',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kText),
              ),
              const SizedBox(height: 8),
              const Text(
                'سيتم التوصيل خلال 30–45 دقيقة',
                style: TextStyle(color: kSub, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(oid, style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('متابعة حالة الطلب 🛵', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(
        onGoProducts: () => setState(() => _idx = 3),
        cartCount: _cartCount,
        onAddToCart: _addMultipleToCart,
        favorites: _favorites,
        onToggleFav: (id) => setState(() {
          if (_favorites.contains(id)) {
            _favorites.remove(id);
          } else {
            _favorites.add(id);
          }
        }),
      ),
      OrdersTab(
        orders: _orders,
        onGoShopping: () => setState(() => _idx = 3),
      ),
      CartTab(
        cart: _cart,
        onSetQty: _setQty,
        onClear: _clearCart,
        onCheckout: _checkout,
        onGoShopping: () => setState(() => _idx = 3),
      ),
      StoreTab(
        favorites: _favorites,
        onAddToCart: _addMultipleToCart,
        cart: _cart,
        onSetQty: _setQty,
        onToggleFav: (id) => setState(() {
          if (_favorites.contains(id)) {
            _favorites.remove(id);
          } else {
            _favorites.add(id);
          }
        }),
      ),
      ProfileTab(
        onLogout: _handleLogout,
      ),
    ];

    return ListenableBuilder(
      listenable: AppLanguage.instance,
      builder: (context, child) {
        return Directionality(
          textDirection: AppLanguage.instance.textDirection,
          child: Container(
            color: const Color(0xFF1E1E24), // Sleek desktop backdrop
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 550), // Mobile frame constraint
                child: Scaffold(
                  body: IndexedStack(index: _idx, children: tabs),
                  bottomNavigationBar: _buildBottomNav(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: AppLanguage.instance.tr('home')),
      _NavItem(icon: Icons.receipt_long_rounded, label: AppLanguage.instance.tr('orders')),
      _NavItem(icon: Icons.shopping_cart_rounded, label: AppLanguage.instance.tr('cart'), badge: _cartCount),
      _NavItem(icon: Icons.storefront_rounded, label: AppLanguage.instance.tr('store')),
      _NavItem(icon: Icons.person_rounded, label: AppLanguage.instance.tr('profile')),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, -2)),
        ],
        border: Border(top: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = _idx == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _idx = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              color: isActive ? kPrimaryBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item.icon,
                              color: isActive ? kPrimary : kSub,
                              size: 24,
                            ),
                          ),
                          if (item.badge > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '${item.badge}',
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                          color: isActive ? kPrimary : kSub,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int badge;
  _NavItem({required this.icon, required this.label, this.badge = 0});
}

