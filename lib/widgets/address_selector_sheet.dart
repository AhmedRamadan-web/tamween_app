import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// ═══════════════════════════════════════════
//  ADDRESS SELECTOR SHEET - HYPER INTERACTIVE
// ═══════════════════════════════════════════
class AddressSelectorSheet extends StatefulWidget {
  final String currentAddress;
  final Function(String) onSelectAddress;

  const AddressSelectorSheet({
    super.key,
    required this.currentAddress,
    required this.onSelectAddress,
  });

  @override
  State<AddressSelectorSheet> createState() => _AddressSelectorSheetState();
}

class _AddressSelectorSheetState extends State<AddressSelectorSheet> {
  late String _selected;

  final List<Map<String, dynamic>> _addresses = [
    {'title': 'المنزل', 'desc': 'المنطقة الحمراء, الرياض - شارع الملك فهد', 'icon': Icons.home_rounded},
    {'title': 'العمل', 'desc': 'حي الملقا, الرياض - برج الأعمال', 'icon': Icons.work_rounded},
    {'title': 'بيت الأهل', 'desc': 'حي الملز, الرياض - شارع الستين', 'icon': Icons.family_restroom_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentAddress;
  }

  void _showAddAddressDialog() {
    final titleCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    IconData selectedIcon = Icons.location_on_rounded;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              top: 24, left: 20, right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45, height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.add_location_alt_rounded, color: kPrimary, size: 26),
                    SizedBox(width: 8),
                    Text('إضافة عنوان توصيل جديد 📍', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('أدخل تفاصيل موقع التوصيل بدقة لخدمتك بشكل أسرع', style: TextStyle(color: kSub, fontSize: 12)),
                const SizedBox(height: 20),

                // Name / Label
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'مسمى العنوان (مثال: الشقة، الاستراحة...)',
                    prefixIcon: const Icon(Icons.bookmark_outline_rounded, color: kPrimary, size: 20),
                    filled: true,
                    fillColor: kBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
                  ),
                ),
                const SizedBox(height: 14),

                // City / District
                TextField(
                  controller: cityCtrl,
                  decoration: InputDecoration(
                    labelText: 'المدينة والحي (مثال: الرياض - حي الياسمين)',
                    prefixIcon: const Icon(Icons.location_city_outlined, color: kPrimary, size: 20),
                    filled: true,
                    fillColor: kBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
                  ),
                ),
                const SizedBox(height: 14),

                // Street
                TextField(
                  controller: streetCtrl,
                  decoration: InputDecoration(
                    labelText: 'الشارع ورقم المبنى',
                    prefixIcon: const Icon(Icons.edit_road_outlined, color: kPrimary, size: 20),
                    filled: true,
                    fillColor: kBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
                  ),
                ),
                const SizedBox(height: 16),

                // Icon selection
                const Text('اختر أيقونة للعنوان:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kText)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _iconChip(Icons.home_rounded, 'المنزل', selectedIcon, (ic) => setDialogState(() => selectedIcon = ic)),
                    const SizedBox(width: 8),
                    _iconChip(Icons.work_rounded, 'العمل', selectedIcon, (ic) => setDialogState(() => selectedIcon = ic)),
                    const SizedBox(width: 8),
                    _iconChip(Icons.family_restroom_rounded, 'الأهل', selectedIcon, (ic) => setDialogState(() => selectedIcon = ic)),
                    const SizedBox(width: 8),
                    _iconChip(Icons.location_on_rounded, 'آخر', selectedIcon, (ic) => setDialogState(() => selectedIcon = ic)),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isEmpty || cityCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('الرجاء إدخال مسمى العنوان والمدينة'), backgroundColor: kRed),
                        );
                        return;
                      }

                      final desc = '${cityCtrl.text}${streetCtrl.text.isNotEmpty ? ' - ${streetCtrl.text}' : ''}';
                      final newAddr = {
                        'title': titleCtrl.text,
                        'desc': desc,
                        'icon': selectedIcon,
                      };

                      setState(() {
                        _addresses.add(newAddr);
                        final fullStr = '${newAddr['title']}: ${newAddr['desc']}';
                        _selected = fullStr;
                        widget.onSelectAddress(fullStr);
                      });

                      Navigator.pop(ctx);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم إضافة وتحديد عنوان "${titleCtrl.text}" بنجاح 📍✓', textAlign: TextAlign.right),
                          backgroundColor: kGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('حفظ وتحديد العنوان 📍', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconChip(IconData icon, String label, IconData selected, Function(IconData) onSelect) {
    final isSel = selected == icon;
    return InkWell(
      onTap: () => onSelect(icon),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? kPrimaryBg : kBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? kPrimary : kBorder, width: isSel ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSel ? kPrimary : kSub),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? kPrimaryDark : kSub)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          top: 16, right: 20, left: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 16),
            const Text('اختر عنوان التوصيل 📍', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
            const SizedBox(height: 6),
            const Text('حدد العنوان الأقرب لتصلك منتجاتك في أسرع وقت', style: TextStyle(color: kSub, fontSize: 12)),
            const SizedBox(height: 18),

            ..._addresses.map((addr) {
              final full = '${addr['title']}: ${addr['desc']}';
              final isSel = _selected.contains(addr['title'] as String);
              return GestureDetector(
                onTap: () {
                  setState(() => _selected = full);
                  widget.onSelectAddress(full);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSel ? kPrimaryBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSel ? kPrimary : kBorder, width: isSel ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSel ? kPrimary : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(addr['icon'] as IconData, color: isSel ? Colors.white : kSub, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(addr['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSel ? kPrimaryDark : kText)),
                            const SizedBox(height: 2),
                            Text(addr['desc'] as String, style: const TextStyle(color: kSub, fontSize: 11)),
                          ],
                        ),
                      ),
                      if (isSel) const Icon(Icons.check_circle_rounded, color: kPrimary, size: 22),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showAddAddressDialog,
              icon: const Icon(Icons.add_location_alt_outlined, color: kPrimary),
              label: const Text('إضافة عنوان جديد 📍', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: kPrimary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

