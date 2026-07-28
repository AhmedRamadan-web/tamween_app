import 'package:flutter/material.dart';

// ═══════════════════════════════════════════
//  DYNAMIC APP LANGUAGE & DIRECTIONALITY
// ═══════════════════════════════════════════
class AppLanguage extends ChangeNotifier {
  static final AppLanguage instance = AppLanguage._();
  AppLanguage._();

  String _currentLang = 'ar'; // 'ar' or 'en'

  String get currentLang => _currentLang;
  bool get isArabic => _currentLang == 'ar';
  TextDirection get textDirection => isArabic ? TextDirection.rtl : TextDirection.ltr;
  Locale get locale => Locale(_currentLang);

  void setLanguage(String langCode) {
    if (_currentLang != langCode) {
      _currentLang = langCode;
      notifyListeners();
    }
  }

  // Translation Dictionary
  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'app_title': 'تموين بلس',
      'home': 'الرئيسية',
      'orders': 'الطلبات',
      'cart': 'سلة الشراء',
      'store': 'المتجر',
      'profile': 'الحساب',
      'search_hint': 'ابحث عن منتج، ماركة، أو قسم...',
      'flash_deals': 'عروض خاطفة 🔥',
      'add_to_cart': 'أضف للسلة',
      'checkout': 'إتمام الطلب 💳',
      'total': 'المجموع الكلي',
      'active_orders': 'الطلبات النشطة',
      'past_orders': 'الطلبات السابقة',
      'track_order': 'تتبع التوصيل 🛵',
      'logout': 'تسجيل الخروج',
      'account_details': 'بيانات الحساب',
      'change_password': 'تعديل كلمة المرور',
      'app_language': 'لغة التطبيق',
      'register_merchant': 'سجل كتاجر في التطبيق',
      'notifications': 'استقبال الإشعارات',
      'contact_us': 'تواصل معنا',
      'faq': 'الأسئلة الشائعة',
      'about_app': 'عن التطبيق',
      'terms': 'الشروط والأحكام',
      'wallet': 'المحفظة',
      'addresses': 'العناوين',
      'verified_account': 'حساب موثق',
      'currency': 'ر.س',
      'select_language': 'اختيار لغة التطبيق',
      'arabic_lang': 'العربية (السعودية)',
      'english_lang': 'English (US)',
      'save_changes': 'حفظ التعديلات',
      'cancel': 'إلغاء',
      'confirm_logout': 'تأكيد الخروج',
    },
    'en': {
      'app_title': 'Tamween Plus',
      'home': 'Home',
      'orders': 'Orders',
      'cart': 'Cart',
      'store': 'Store',
      'profile': 'Profile',
      'search_hint': 'Search product, brand, or category...',
      'flash_deals': 'Flash Deals 🔥',
      'add_to_cart': 'Add to Cart',
      'checkout': 'Checkout 💳',
      'total': 'Total Amount',
      'active_orders': 'Active Orders',
      'past_orders': 'Past Orders',
      'track_order': 'Track Order 🛵',
      'logout': 'Logout',
      'account_details': 'Account Details',
      'change_password': 'Change Password',
      'app_language': 'App Language',
      'register_merchant': 'Become a Merchant',
      'notifications': 'Push Notifications',
      'contact_us': 'Contact Us',
      'faq': 'FAQ',
      'about_app': 'About App',
      'terms': 'Terms & Conditions',
      'wallet': 'Wallet',
      'addresses': 'Addresses',
      'verified_account': 'Verified Account',
      'currency': 'SAR',
      'select_language': 'Select App Language',
      'arabic_lang': 'العربية (السعودية)',
      'english_lang': 'English (US)',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'confirm_logout': 'Confirm Logout',
    },
  };

  String tr(String key) {
    return _localizedValues[_currentLang]?[key] ?? key;
  }
}
