import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/product.dart';

// ═══════════════════════════════════════════
//  PRODUCT DETAILS SHEET
// ═══════════════════════════════════════════
class ProductDetailsSheet extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final Function(Product, int) onAddToCart;
  final VoidCallback onToggleFav;

  const ProductDetailsSheet({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onAddToCart,
    required this.onToggleFav,
  });

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int _qty = 1;
  late bool _fav;

  @override
  void initState() {
    super.initState();
    _fav = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final totalPrice = p.price * _qty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Top Handle Indicator
            const SizedBox(height: 12),
            Container(
              width: 44, height: 5,
              decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(3)),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Container
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: kBg,
                            child: Image.network(
                              p.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: kPrimaryBg,
                                child: const Icon(Icons.inventory_2_rounded, size: 60, color: kPrimary),
                              ),
                            ),
                          ),
                        ),
                        // Favorite Button Top Left
                        Positioned(
                          top: 12,
                          left: 12,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _fav = !_fav);
                              widget.onToggleFav();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                              ),
                              child: Icon(
                                _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: _fav ? kPrimary : kSub,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        // Discount Tag Top Right
                        if (p.discountPercent > 0)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: kOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'خصم ${p.discountPercent}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Rating & Origin Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFECB3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${p.rating}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kText),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${p.reviewsCount} تقييم)',
                                style: const TextStyle(color: kSub, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: kPrimaryBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            p.origin,
                            style: const TextStyle(color: kPrimaryDark, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title & Unit
                    Text(
                      p.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'العبوة: ${p.unit}',
                      style: const TextStyle(color: kSub, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),

                    // Price Section
                    Row(
                      children: [
                        Text(
                          '${p.price.toStringAsFixed(2)} ريال',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kPrimary),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${p.oldPrice.toStringAsFixed(2)} ريال',
                          style: const TextStyle(fontSize: 14, color: kSub, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                    const Divider(height: 28),

                    // Description
                    const Text(
                      'تفاصيل الوصف والجودة 🍃',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.description,
                      style: const TextStyle(color: Color(0xFF64748B), height: 1.6, fontSize: 13),
                    ),
                    const SizedBox(height: 18),

                    // Guarantees Row
                    Row(
                      children: [
                        Expanded(child: _badgeTile(Icons.local_shipping_outlined, 'توصيل سريعة', 'خلال 45 دقيقة')),
                        const SizedBox(width: 10),
                        Expanded(child: _badgeTile(Icons.verified_user_outlined, 'ضمان طازج', '100% مضمون')),
                        const SizedBox(width: 10),
                        Expanded(child: _badgeTile(Icons.assignment_return_outlined, 'إرجاع مجاني', 'عند الاستلام')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Action Bar
            Container(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 14,
                bottom: MediaQuery.of(context).padding.bottom + 14,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -3))],
                border: Border(top: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  // Quantity Counter Button
                  Container(
                    decoration: BoxDecoration(
                      color: kBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kBorder),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => _qty++),
                          icon: const Icon(Icons.add_rounded, color: kPrimary, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$_qty',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_qty > 1) setState(() => _qty--);
                          },
                          icon: Icon(Icons.remove_rounded, color: _qty > 1 ? kText : kSub, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onAddToCart(p, _qty);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                        label: Text(
                          'أضف للسلة (${totalPrice.toStringAsFixed(2)} ر.س)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: const Color(0x5500BFA5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeTile(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimary, size: 20),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kText)),
          Text(sub, style: const TextStyle(fontSize: 9, color: kSub)),
        ],
      ),
    );
  }
}
