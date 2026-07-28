class Product {
  final int id;
  final String name;
  final String unit;
  final double price;
  final double oldPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewsCount;
  final String description;
  final String origin;
  final bool isFlashDeal;
  final int discountPercent;

  const Product({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 4.8,
    this.reviewsCount = 124,
    this.description = 'منتج طازج عالي الجودة مختار بعناية فائقة وتغليف صحي آمن يومياً يصلك لباب منزلك.',
    this.origin = '🇸🇦 إنتاج محلي طازج',
    this.isFlashDeal = false,
    this.discountPercent = 20,
  });
}
