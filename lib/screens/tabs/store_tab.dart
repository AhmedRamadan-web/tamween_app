import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/product_details_sheet.dart';

// ═══════════════════════════════════════════
//  STORE TAB - HYPER PROFESSIONAL STORE
// ═══════════════════════════════════════════
class StoreTab extends StatefulWidget {
  final Set<int> favorites;
  final Function(Product, int) onAddToCart;
  final List<CartItem> cart;
  final Function(int, int) onSetQty;
  final Function(int) onToggleFav;

  const StoreTab({
    super.key,
    required this.favorites,
    required this.onAddToCart,
    required this.cart,
    required this.onSetQty,
    required this.onToggleFav,
  });

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  String _category = 'all';
  String _sort = 'popular';
  RangeValues _priceRange = const RangeValues(0, 400);
  bool _isGridView = false;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        selectedCategory: _category,
        selectedSort: _sort,
        priceRange: _priceRange,
        onApply: (cat, sort, price) {
          setState(() {
            _category = cat;
            _sort = sort;
            _priceRange = price;
          });
        },
      ),
    );
  }

  void _openProductDetails(Product p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductDetailsSheet(
        product: p,
        isFavorite: widget.favorites.contains(p.id),
        onAddToCart: (prod, qty) => widget.onAddToCart(prod, qty),
        onToggleFav: () => widget.onToggleFav(p.id),
      ),
    );
  }

  List<Product> get _filteredList {
    List<Product> list = kProducts;

    // Category
    if (_category != 'all') {
      list = list.where((p) => p.category == _category).toList();
    }

    // Search
    if (_search.trim().isNotEmpty) {
      list = list.where((p) => p.name.contains(_search.trim())).toList();
    }

    // Price
    list = list.where((p) => p.price >= _priceRange.start && p.price <= _priceRange.end).toList();

    // Sort
    if (_sort == 'price_low') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sort == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4DD0C4), kPrimary, kPrimaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _openFilterSheet,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'متجر كـــارفور 🛒',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isGridView = !_isGridView),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                          child: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      textAlign: TextAlign.right,
                      onChanged: (v) => setState(() => _search = v),
                      decoration: const InputDecoration(
                        hintText: 'ابحث في أصناف المتجر...',
                        hintStyle: TextStyle(color: kSub, fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: kSub, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _openFilterSheet,
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt_outlined, color: kPrimary, size: 18),
                      SizedBox(width: 4),
                      Text('تصفية النتائج', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                Text('${list.length} منتج متوفر', style: const TextStyle(color: kSub, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Products List / Grid
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('لا توجد منتجات تطابق البحث والفلترة', style: TextStyle(color: kSub, fontSize: 14)))
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: list.length,
                        itemBuilder: (ctx, i) => _gridProductCard(list[i]),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        itemBuilder: (ctx, i) => _listProductCard(list[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _listProductCard(Product p) {
    final ci = widget.cart.where((c) => c.product.id == p.id).firstOrNull;
    final qty = ci?.quantity ?? 0;
    final isFav = widget.favorites.contains(p.id);

    return GestureDetector(
      onTap: () => _openProductDetails(p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.onToggleFav(p.id);
                setState(() {});
              },
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? kPrimary : const Color(0xFFE0E0E0),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(p.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kText)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(20)),
                    child: Text(p.unit, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${p.price.toStringAsFixed(2)} ريال', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: kText)),
                      const SizedBox(width: 8),
                      Text('${p.oldPrice.toStringAsFixed(2)}ريال', style: const TextStyle(color: kSub, decoration: TextDecoration.lineThrough, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  qty > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _qBtn(Icons.add_rounded, () { widget.onSetQty(p.id, qty + 1); setState(() {}); }, plus: true),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                            _qBtn(Icons.remove_rounded, () { widget.onSetQty(p.id, qty - 1); setState(() {}); }, plus: false),
                          ],
                        )
                      : GestureDetector(
                          onTap: () { widget.onAddToCart(p, 1); setState(() {}); },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: kPrimaryBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart_outlined, color: kPrimary, size: 15),
                                SizedBox(width: 4),
                                Text('أضف للسلة', style: TextStyle(color: kPrimaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(p.imageUrl, width: 90, height: 90, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridProductCard(Product p) {
    final isFav = widget.favorites.contains(p.id);
    return GestureDetector(
      onTap: () => _openProductDetails(p),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(p.imageUrl, height: 110, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: GestureDetector(
                    onTap: () {
                      widget.onToggleFav(p.id);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? kPrimary : kSub, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kText)),
            Text(p.unit, style: const TextStyle(color: kSub, fontSize: 10)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${p.price.toStringAsFixed(2)} ر.س', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w900, fontSize: 13)),
                GestureDetector(
                  onTap: () => widget.onAddToCart(p, 1),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qBtn(IconData icon, VoidCallback onTap, {required bool plus}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: plus ? kPrimary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: plus ? kPrimary : kBorder),
        ),
        child: Icon(icon, size: 16, color: plus ? Colors.white : kText),
      ),
    );
  }
}
