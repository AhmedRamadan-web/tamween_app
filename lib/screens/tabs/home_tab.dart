import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/models/product.dart';
import '../../widgets/address_selector_sheet.dart';
import '../../widgets/product_details_sheet.dart';

// ═══════════════════════════════════════════
//  HOME TAB - HIGHLY INTERACTIVE & BEAUTIFUL
// ═══════════════════════════════════════════
class HomeTab extends StatefulWidget {
  final VoidCallback onGoProducts;
  final int cartCount;
  final Function(Product, int) onAddToCart;
  final Set<int> favorites;
  final Function(int) onToggleFav;

  const HomeTab({
    super.key,
    required this.onGoProducts,
    required this.cartCount,
    required this.onAddToCart,
    required this.favorites,
    required this.onToggleFav,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _activeCat = 'all';
  String _currentAddress = 'المنزل: المنطقة الحمراء, الرياض';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final _cats = [
    {'id': 'all',     'label': 'الكل',         'icon': Icons.grid_view_rounded},
    {'id': 'veggies', 'label': 'الخضراوات',    'icon': Icons.eco_rounded},
    {'id': 'dates',   'label': 'التمور',       'icon': Icons.bakery_dining_rounded},
    {'id': 'tamween', 'label': 'التموين',      'icon': Icons.inventory_2_rounded},
    {'id': 'snacks',  'label': 'سناكس',        'icon': Icons.fastfood_rounded},
    {'id': 'meat',    'label': 'اللحوم',       'icon': Icons.set_meal_rounded},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openAddressPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddressSelectorSheet(
        currentAddress: _currentAddress,
        onSelectAddress: (addr) => setState(() => _currentAddress = addr),
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
        onAddToCart: widget.onAddToCart,
        onToggleFav: () => widget.onToggleFav(p.id),
      ),
    );
  }

  List<Product> get _filteredProducts {
    List<Product> list = kProducts;
    if (_activeCat != 'all') {
      list = list.where((p) => p.category == _activeCat).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      list = list.where((p) => p.name.contains(_searchQuery.trim())).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final flashDeals = kProducts.where((p) => p.isFlashDeal).toList();

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── Premium Teal Top Header ──
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C9A7), kPrimary, kPrimaryDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 18,
                right: 16, left: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'مرحباً بك في تموين بلس 👋',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: Colors.amber, size: 14),
                            SizedBox(width: 4),
                            Text('توصيل خلال 30د', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location Selector Button
                  GestureDetector(
                    onTap: _openAddressPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _currentAddress,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      textAlign: TextAlign.right,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن فواكه، تمور، رز أو تموين...',
                        hintStyle: const TextStyle(color: kSub, fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded, color: kPrimary, size: 22),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: kSub, size: 18),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : const Icon(Icons.tune_rounded, color: kSub, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),

                // ── CashBack Banner Carousel ──
                GestureDetector(
                  onTap: widget.onGoProducts,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00BFA5), Color(0xFF00796B)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x3300BFA5), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=200&auto=format&fit=crop&q=60',
                            width: 85, height: 85, fit: BoxFit.cover,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(12)),
                              child: const Text('عرض محدود 🔥', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 4),
                            const Text('36% كاش باك حصري', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            const Text('عند شائك بـ 60 ريال فأكثر', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: const Text('استخدم كود: Tamween', style: TextStyle(color: kPrimaryDark, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Categories List ──
                SizedBox(
                  height: 76,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    reverse: true,
                    itemCount: _cats.length,
                    itemBuilder: (ctx, i) {
                      final cat = _cats[i];
                      final isActive = _activeCat == cat['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _activeCat = cat['id'] as String),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? kPrimary : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isActive ? kPrimary : kBorder),
                            boxShadow: isActive
                                ? [const BoxShadow(color: Color(0x4000BFA5), blurRadius: 8, offset: Offset(0, 3))]
                                : [const BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat['icon'] as IconData, color: isActive ? Colors.white : kSub, size: 22),
                              const SizedBox(height: 4),
                              Text(
                                cat['label'] as String,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? Colors.white : kText),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ── Flash Deals Header & Horizontal Scroll ──
                if (_searchQuery.isEmpty && flashDeals.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.timer_outlined, color: kRed, size: 14),
                              SizedBox(width: 4),
                              Text('ينتهي خلال 03:45:12', style: TextStyle(color: kRed, fontWeight: FontWeight.bold, fontSize: 11)),
                            ],
                          ),
                        ),
                        const Text('عروض صيد اليوم ⚡️', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kText)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      reverse: true,
                      itemCount: flashDeals.length,
                      itemBuilder: (ctx, i) {
                        final p = flashDeals[i];
                        return _flashDealCard(p);
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                ],

                // ── All Products Grid ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_filteredProducts.length} صنف متوفر', style: const TextStyle(color: kSub, fontSize: 12)),
                      const Text('الأصناف الأكثر طلباً 🛒', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kText)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                ..._filteredProducts.map((p) => _productRowCard(p)),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _flashDealCard(Product p) {
    return GestureDetector(
      onTap: () => _openProductDetails(p),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(p.imageUrl, width: 140, height: 100, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(10)),
                    child: Text(' خصم ${p.discountPercent}%', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${p.price.toStringAsFixed(2)} ر.س', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w900, fontSize: 13)),
                    Text('${p.oldPrice.toStringAsFixed(2)} ر.س', style: const TextStyle(color: kSub, decoration: TextDecoration.lineThrough, fontSize: 10)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    widget.onAddToCart(p, 1);
                  },
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

  Widget _productRowCard(Product p) {
    return GestureDetector(
      onTap: () => _openProductDetails(p),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(p.imageUrl, width: 85, height: 85, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kText)),
                      const Spacer(),
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 16),
                      Text(' ${p.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: kText)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(p.unit, style: const TextStyle(color: kSub, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${p.price.toStringAsFixed(2)} ريال', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: kPrimary)),
                          const SizedBox(width: 6),
                          Text('${p.oldPrice.toStringAsFixed(2)} ريال', style: const TextStyle(color: kSub, decoration: TextDecoration.lineThrough, fontSize: 11)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => widget.onAddToCart(p, 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBg,
                          foregroundColor: kPrimaryDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart_rounded, size: 15),
                            SizedBox(width: 4),
                            Text('أضف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
