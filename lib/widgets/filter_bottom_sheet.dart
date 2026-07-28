import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// ═══════════════════════════════════════════
//  FILTER & SORT BOTTOM SHEET
// ═══════════════════════════════════════════
class FilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final String selectedSort;
  final RangeValues priceRange;
  final Function(String category, String sort, RangeValues price) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.selectedSort,
    required this.priceRange,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _category;
  late String _sort;
  late RangeValues _price;

  final _sortOptions = [
    {'id': 'popular', 'label': 'الأكثر مبيعاً 🔥'},
    {'id': 'price_low', 'label': 'السعر: من الأقل للأعلى 💵'},
    {'id': 'rating', 'label': 'الأعلى تقييماً ⭐'},
    {'id': 'newest', 'label': 'المنتجات الأحدث 🆕'},
  ];

  final _categories = [
    {'id': 'all', 'label': 'جميع المنتجات'},
    {'id': 'veggies', 'label': 'الخضراوات والفواكه'},
    {'id': 'dates', 'label': 'التمور الفاخرة'},
    {'id': 'tamween', 'label': 'التموين والأرز'},
    {'id': 'snacks', 'label': 'سناكس وتسالي'},
    {'id': 'meat', 'label': 'اللحوم والدواجن'},
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
    _sort = widget.selectedSort;
    _price = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
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
                  const Text('تصفية وترتيب المنتجات 🎯', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _category = 'all';
                        _sort = 'popular';
                        _price = const RangeValues(0, 400);
                      });
                    },
                    child: const Text('إعادة ضبط', style: TextStyle(color: kRed, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort By
                    const Text('ترتيب حسب', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((opt) {
                        final selected = _sort == opt['id'];
                        return ChoiceChip(
                          label: Text(opt['label']!),
                          selected: selected,
                          selectedColor: kPrimaryBg,
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            color: selected ? kPrimaryDark : kText,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: selected ? kPrimary : Colors.transparent),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _sort = opt['id']!);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Price Range Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_price.start.toInt()} ر.س – ${_price.end.toInt()} ر.س',
                          style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Text('نطاق السعر', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
                      ],
                    ),
                    RangeSlider(
                      values: _price,
                      min: 0,
                      max: 400,
                      divisions: 40,
                      activeColor: kPrimary,
                      inactiveColor: const Color(0xFFE2E8F0),
                      labels: RangeLabels(
                        '${_price.start.toInt()} ر.س',
                        '${_price.end.toInt()} ر.س',
                      ),
                      onChanged: (vals) => setState(() => _price = vals),
                    ),
                    const SizedBox(height: 20),

                    // Categories Grid
                    const Text('التصنيف الرئيسية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final selected = _category == cat['id'];
                        return ChoiceChip(
                          label: Text(cat['label']!),
                          selected: selected,
                          selectedColor: kPrimary,
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : kText,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _category = cat['id']!);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Apply Button
            Container(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 14,
                bottom: MediaQuery.of(context).padding.bottom + 14,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: kBorder)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_category, _sort, _price);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0x5500BFA5),
                  ),
                  child: const Text('تطبيق التصفية والنتائج ✨', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
