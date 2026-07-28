import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/order_model.dart';

// ═══════════════════════════════════════════
//  ORDER TRACKING SHEET
// ═══════════════════════════════════════════
class OrderTrackingSheet extends StatelessWidget {
  final OrderModel order;
  const OrderTrackingSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 44, height: 5, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('متابعة الطلب ${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                      const SizedBox(height: 2),
                      const Text('الوقت المتوقع للتوصيل: 25 - 35 دقيقة ⚡️', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: kSub),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Driver Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0F7F5), Color(0xFFB2DFDB)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kPrimary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Center(child: Icon(Icons.person_pin_rounded, color: kPrimary, size: 36)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('أحمد العتيبي', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: kText)),
                                    SizedBox(width: 6),
                                    Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
                                    Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: kText)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text('سائق التوصيل • تويوتا يارس (أ ح د 1234)', style: TextStyle(color: kPrimaryDark, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('جاري الاتصال بالسائق أحمد العتيبي 📞', textAlign: TextAlign.right),
                                    backgroundColor: kPrimary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Timeline Progress
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('مراحل التوصيل المباشرة 🛵', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
                    ),
                    const SizedBox(height: 16),

                    _stepTile(
                      title: 'تم استلام الطلب وتأكيده',
                      time: '09:30 م',
                      isDone: true,
                      isActive: false,
                      icon: Icons.check_circle_rounded,
                    ),
                    _stepTile(
                      title: 'جاري تجهيز وتغليف المنتجات طازجة',
                      time: '09:34 م',
                      isDone: true,
                      isActive: false,
                      icon: Icons.inventory_2_rounded,
                    ),
                    _stepTile(
                      title: 'مندوب التوصيل في الطريق إليك',
                      time: 'الآن (متوقع 09:50 م)',
                      isDone: false,
                      isActive: true,
                      icon: Icons.delivery_dining_rounded,
                    ),
                    _stepTile(
                      title: 'تم التسليم لباب المنزل',
                      time: '-- : --',
                      isDone: false,
                      isActive: false,
                      icon: Icons.home_rounded,
                      isLast: true,
                    ),
                    const SizedBox(height: 24),

                    // Order Summary Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${order.items.length} منتجات', style: const TextStyle(color: kSub, fontSize: 13)),
                              const Text('ملخص الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          const Divider(height: 16),
                          ...order.items.map((it) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${(it.product.price * it.quantity).toStringAsFixed(2)} ر.س', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                Text('• ${it.product.name} (×${it.quantity})', style: const TextStyle(fontSize: 12, color: kText)),
                              ],
                            ),
                          )),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${order.total.toStringAsFixed(2)} ريال', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kPrimary)),
                              const Text('الإجمالي المدفوع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepTile({
    required String title,
    required String time,
    required bool isDone,
    required bool isActive,
    required IconData icon,
    bool isLast = false,
  }) {
    final color = isDone
        ? kPrimary
        : isActive
            ? kOrange
            : const Color(0xFFCBD5E1);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot & Vertical Line
          Column(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: isActive ? kOrange.withValues(alpha: 0.15) : (isDone ? kPrimaryBg : const Color(0xFFF1F5F9)),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? kPrimary : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Text Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.w500,
                      color: isActive ? kOrange : (isDone ? kText : kSub),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(color: isActive ? kOrange : kSub, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
