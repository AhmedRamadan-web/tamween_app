import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/cart_item.dart';

// ═══════════════════════════════════════════
//  CART TAB
// ═══════════════════════════════════════════
class CartTab extends StatefulWidget {
  final List<CartItem> cart;
  final Function(int, int) onSetQty;
  final VoidCallback onClear;
  final Function(double) onCheckout;
  final VoidCallback onGoShopping;

  const CartTab({
    super.key,
    required this.cart,
    required this.onSetQty,
    required this.onClear,
    required this.onCheckout,
    required this.onGoShopping,
  });

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final _promoCtrl = TextEditingController();
  double _disc = 0;
  String _promoMsg = '';
  bool _promoOk = false;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  double get sub   => widget.cart.fold(0, (s, c) => s + c.product.price * c.quantity);
  double get del   => sub >= 150 ? 0 : 15;
  double get vat   => sub * 0.15;
  double get disc  => sub * _disc;
  double get grand => (sub + del + vat - disc).clamp(0.0, double.infinity);

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toLowerCase();
    setState(() {
      if (code == 'tamween' || code == 'تموين') {
        _disc = 0.36;
        _promoMsg = '✓ تم تطبيق كود Tamween – خصم 36%';
        _promoOk = true;
      } else if (code == 'save10') {
        _disc = 0.10;
        _promoMsg = '✓ تم تطبيق كود SAVE10 – خصم 10%';
        _promoOk = true;
      } else {
        _disc = 0;
        _promoMsg = '✗ الكود غير صحيح';
        _promoOk = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cart.isEmpty) return _emptyState();
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('سلة الشراء', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('${widget.cart.length} منتج', style: const TextStyle(color: kSub, fontSize: 11, fontWeight: FontWeight.normal)),
        ]),
        backgroundColor: Colors.white,
        foregroundColor: kText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: widget.onClear,
            icon: const Icon(Icons.delete_outline_rounded, color: kRed, size: 18),
            label: const Text('مسح الكل', style: TextStyle(color: kRed, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Address
                _card(Row(children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('عنوان التوصيل', style: TextStyle(color: kSub, fontSize: 11)),
                    SizedBox(height: 2),
                    Text('المنزل – المنطقة الحمراء', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ])),
                  const SizedBox(width: 10),
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: kPrimaryBg, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on_rounded, color: kPrimary, size: 22)),
                  const SizedBox(width: 10),
                  const Text('تغيير', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                ])),
                const SizedBox(height: 12),

                // Items
                ...widget.cart.map((ci) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _card(Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(ci.product.imageUrl, width: 72, height: 72, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: kPrimaryBg, child: const Icon(Icons.inventory_2_rounded, color: kPrimary))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(ci.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(ci.product.unit, style: const TextStyle(color: kOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${(ci.product.price * ci.quantity).toStringAsFixed(2)} ريال', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w900, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        _qBtn(Icons.add_rounded, () => widget.onSetQty(ci.product.id, ci.quantity + 1), plus: true),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${ci.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                        _qBtn(Icons.remove_rounded, () => widget.onSetQty(ci.product.id, ci.quantity - 1), plus: false),
                      ]),
                    ])),
                    const SizedBox(width: 6),
                    GestureDetector(onTap: () => widget.onSetQty(ci.product.id, 0), child: const Icon(Icons.close_rounded, color: kSub, size: 18)),
                  ])),
                )),

                // Promo
                _card(Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('🏷️ هل لديك كود خصم؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(children: [
                    ElevatedButton(
                      onPressed: _applyPromo,
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13)),
                      child: const Text('تطبيق', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(
                      controller: _promoCtrl,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Tamween',
                        filled: true, fillColor: kBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPrimary)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                        isDense: true,
                      ),
                    )),
                  ]),
                  if (_promoMsg.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_promoMsg, style: TextStyle(color: _promoOk ? kGreen : kRed, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ])),
                const SizedBox(height: 12),

                // Bill
                _card(Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('تفاصيل الفاتورة 📑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(height: 20),
                  _billRow('مجموع المنتجات', '${sub.toStringAsFixed(2)} ريال'),
                  _billRow('رسوم التوصيل', del == 0 ? 'مجاني 🎉' : '${del.toStringAsFixed(2)} ريال', valColor: del == 0 ? kGreen : null),
                  _billRow('ضريبة القيمة المضافة 15%', '${vat.toStringAsFixed(2)} ريال'),
                  if (disc > 0) _billRow('الخصم', '− ${disc.toStringAsFixed(2)} ريال', valColor: kGreen, bold: true),
                  const Divider(height: 18, color: kBorder),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${grand.toStringAsFixed(2)} ريال', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: kPrimary)),
                    const Text('المبلغ الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ]),
                ])),
                const SizedBox(height: 14),
              ],
            ),
          ),

          // Checkout bar
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))]),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('الإجمالي', style: TextStyle(color: kSub, fontSize: 11)),
                Text('${grand.toStringAsFixed(2)} ريال', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
              ]),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onCheckout(grand),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4, shadowColor: const Color(0x5500BFA5),
                  ),
                  child: const Text('إتمام الطلب والدفع ←', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline_rounded, color: kText, size: 22),
      ),
      title: const Text('سلة التسوق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      centerTitle: true,
      actions: [Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.chevron_left_rounded, color: kText, size: 22))],
    ),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _cartEmptyIllustration(),
      const SizedBox(height: 28),
      const Text('سلة الشراء فارغة حالياً', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kText)),
      const SizedBox(height: 8),
      const Text('ابدأ التسوق و الطلب الان', style: TextStyle(color: kSub, fontSize: 13)),
      const SizedBox(height: 32),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onGoShopping,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary, foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4, shadowColor: const Color(0x5500BFA5),
            ),
            child: const Text('ابدأ التسوق الان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    ])),
  );

  Widget _cartEmptyIllustration() {
    return Container(
      width: 200, height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 24, right: 30,
            child: Container(
              width: 60, height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            top: 14, right: 50,
            child: Container(
              width: 40, height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            child: Container(
              width: 100, height: 70,
              decoration: const BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (_) => Container(
                  width: 8, height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
            ),
          ),
          Positioned(
            bottom: 90, left: 44,
            child: Container(
              width: 20, height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimary, width: 4),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
          ),
          Positioned(
            bottom: 90, right: 44,
            child: Container(
              width: 20, height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimary, width: 4),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
          ),
          Positioned(
            bottom: 116, left: 46,
            child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle)),
          ),
          Positioned(
            bottom: 116, right: 46,
            child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle)),
          ),
        ],
      ),
    );
  }

  Widget _qBtn(IconData icon, VoidCallback onTap, {required bool plus}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: plus ? kPrimary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: plus ? kPrimary : kBorder),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(icon, size: 17, color: plus ? Colors.white : kText),
      ),
    );
  }

  Widget _billRow(String label, String value, {Color? valColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(value, style: TextStyle(color: valColor ?? kText, fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
        Text(label, style: const TextStyle(color: kSub, fontSize: 13)),
      ]),
    );
  }

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBorder), boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2))]),
    child: child,
  );
}
