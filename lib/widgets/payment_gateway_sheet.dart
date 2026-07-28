import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// ═══════════════════════════════════════════
//  PAYMENT GATEWAY SHEET
// ═══════════════════════════════════════════
class PaymentGatewaySheet extends StatefulWidget {
  final double total;
  final VoidCallback onPaymentSuccess;
  const PaymentGatewaySheet({
    super.key,
    required this.total,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentGatewaySheet> createState() => _PaymentGatewaySheetState();
}

class _PaymentGatewaySheetState extends State<PaymentGatewaySheet> {
  String _method = 'mada';
  bool _loading = false;

  final _cardNumberCtrl = TextEditingController(text: '4000 1234 5678 9010');
  final _expiryCtrl = TextEditingController(text: '08/28');
  final _cvvCtrl = TextEditingController(text: '123');
  final _nameCtrl = TextEditingController(text: 'محمد خالد ابراهيم');

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _pay() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    widget.onPaymentSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          top: 20, right: 20, left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('بوابة الدفع الإلكتروني 💳', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: kSub)),
                ],
              ),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: kPrimaryBg, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي المبلغ المراد دفعه', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kText)),
                    Text('${widget.total.toStringAsFixed(2)} ريال', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimary)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('اختر طريقة الدفع', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kSub)),
              const SizedBox(height: 10),
              _methodTile('mada', '🇸🇦 مدى (Mada)', Icons.credit_card_rounded),
              _methodTile('apple_pay', ' Apple Pay', Icons.phone_iphone_rounded),
              _methodTile('card', '💳 فيزا / ماستركارد', Icons.payment_rounded),
              _methodTile('cash', '💵 الدفع عند الاستلام', Icons.local_atm_rounded),
              
              if (_method == 'card' || _method == 'mada') ...[
                const SizedBox(height: 14),
                const Text('بيانات البطاقة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kText)),
                const SizedBox(height: 8),
                _input('اسم حامل البطاقة', _nameCtrl, Icons.person_outline_rounded),
                const SizedBox(height: 8),
                _input('رقم البطاقة', _cardNumberCtrl, Icons.credit_card_rounded, keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _input('تاريخ الانتهاء', _expiryCtrl, Icons.calendar_today_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _input('الرمز السري (CVV)', _cvvCtrl, Icons.lock_outline_rounded, obscure: true)),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0x5500BFA5),
                  ),
                  child: _loading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          _method == 'cash'
                              ? 'تأكيد الطلب 🚚'
                              : 'دفع ${widget.total.toStringAsFixed(2)} ريال 🔒',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTile(String id, String label, IconData icon) {
    final selected = _method == id;
    return GestureDetector(
      onTap: () => setState(() => _method = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? kPrimaryBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? kPrimary : kBorder, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? kPrimary : kSub, size: 22),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.w600, color: kText, fontSize: 14)),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle_rounded, color: kPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller, IconData icon, {TextInputType? keyboardType, bool obscure = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: kSub),
        filled: true,
        fillColor: kBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPrimary)),
        isDense: true,
      ),
    );
  }
}
