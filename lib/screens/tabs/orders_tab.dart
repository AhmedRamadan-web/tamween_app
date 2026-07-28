import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../widgets/order_tracking_sheet.dart';

// ═══════════════════════════════════════════
//  ORDERS TAB - WITH LIVE TRACKING
// ═══════════════════════════════════════════
class OrdersTab extends StatefulWidget {
  final List<OrderModel> orders;
  final VoidCallback onGoShopping;
  const OrdersTab({super.key, required this.orders, required this.onGoShopping});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _openTrackingSheet(OrderModel o) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OrderTrackingSheet(order: o),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('طلباتي ومتابعة التوصيل 📦', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: kText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tab,
          labelColor: kPrimary,
          unselectedLabelColor: kSub,
          indicatorColor: kPrimary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal', fontSize: 13),
          tabs: [
            Tab(text: 'الحالية المباشرة (${widget.orders.where((o) => o.isDelivering).length})'),
            Tab(text: 'السابقة المكتملة (${widget.orders.where((o) => !o.isDelivering).length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _list(widget.orders.where((o) => o.isDelivering).toList()),
          _list(widget.orders.where((o) => !o.isDelivering).toList()),
        ],
      ),
    );
  }

  Widget _list(List<OrderModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180, height: 180,
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
              child: const Icon(Icons.receipt_long_outlined, size: 70, color: kSub),
            ),
            const SizedBox(height: 24),
            const Text('لا توجد طلبات في القائمة حالياً', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kText)),
            const SizedBox(height: 6),
            const Text('ابدأ التسوق من أفضل الأصناف والتموين الآن', style: TextStyle(color: kSub, fontSize: 13)),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onGoShopping,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shadowColor: const Color(0x5500BFA5),
                  ),
                  child: const Text('تسوق الآن ✨', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final o = list[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder),
            boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('طلب ${o.id}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: kText)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: o.isDelivering ? kPrimaryBg : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      o.isDelivering ? 'جاري التوصيل 🛵' : 'مكتمل ✓',
                      style: TextStyle(color: o.isDelivering ? kPrimaryDark : Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(o.date, style: const TextStyle(color: kSub, fontSize: 11)),
              const Divider(height: 20),
              ...o.items.map((ci) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('• ${ci.product.name} (×${ci.quantity})', style: const TextStyle(fontSize: 13, color: kText)),
                    Text('${(ci.product.price * ci.quantity).toStringAsFixed(2)} ريال', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              )),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${o.total.toStringAsFixed(2)} ريال', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: kPrimary)),
                    ],
                  ),
                  if (o.isDelivering)
                    ElevatedButton.icon(
                      onPressed: () => _openTrackingSheet(o),
                      icon: const Icon(Icons.near_me_rounded, size: 16),
                      label: const Text('تتبع التوصيل 🛵', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
