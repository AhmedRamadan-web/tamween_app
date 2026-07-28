import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/address_selector_sheet.dart';

// ═══════════════════════════════════════════
//  PROFILE TAB - HYPER INTERACTIVE & COMPLETE
// ═══════════════════════════════════════════
class ProfileTab extends StatefulWidget {
  final VoidCallback onLogout;
  const ProfileTab({super.key, required this.onLogout});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notifEnabled = true;

  // Profile User State
  String _userName = 'محمد خالد ابراهيم';
  String _userEmail = 'm.khaled@example.com';
  String _userPhone = '0505000000';
  String _selectedLanguage = 'العربية (السعودية)';
  String _currentAddress = 'المنطقة الحمراء, الرياض - شارع الملك فهد';

  // ── Logout Confirmation ──
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          icon: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout_rounded, color: Color(0xFFFF3B30), size: 32),
          ),
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج من تطبيق تموين بلس؟',
            textAlign: TextAlign.center,
            style: TextStyle(color: kSub, fontSize: 13),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: kBorder),
                    ),
                    child: const Text('إلغاء', style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3B30),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 2,
                    ),
                    child: const Text('تأكيد الخروج', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── 1. Edit Profile Sheet ──
  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);
    final phoneCtrl = TextEditingController(text: _userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
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
                  Icon(Icons.person_rounded, color: kPrimary, size: 24),
                  SizedBox(width: 8),
                  Text('تعديل بيانات الحساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField('الاسم الكامل', nameCtrl, Icons.person_outline),
              const SizedBox(height: 14),
              _buildTextField('البريد الإلكتروني', emailCtrl, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildTextField('رقم الجوال', phoneCtrl, Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userName = nameCtrl.text;
                      _userEmail = emailCtrl.text;
                      _userPhone = phoneCtrl.text;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث بيانات الحساب بنجاح ✓'), backgroundColor: kGreen),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('حفظ التعديلات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 2. Change Password Sheet ──
  void _showChangePasswordSheet() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
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
                  Icon(Icons.lock_reset_rounded, color: kPrimary, size: 24),
                  SizedBox(width: 8),
                  Text('تعديل كلمة المرور', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField('كلمة المرور الحالية', oldPass, Icons.lock_outline, isPassword: true),
              const SizedBox(height: 14),
              _buildTextField('كلمة المرور الجديدة', newPass, Icons.lock_outline, isPassword: true),
              const SizedBox(height: 14),
              _buildTextField('تأكيد كلمة المرور الجديدة', confirmPass, Icons.lock_outline, isPassword: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (newPass.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء إدخال كلمة المرور الجديدة'), backgroundColor: kRed),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح 🔒'), backgroundColor: kGreen),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('تحديث كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 3. Language Selector Sheet ──
  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                const Text('اختيار لغة التطبيق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                const SizedBox(height: 16),
                _langOption('🇸🇦', 'العربية (السعودية)', 'العربية هي اللغة الافتراضية', AppLanguage.instance.isArabic, () {
                  setSheetState(() => _selectedLanguage = 'العربية (السعودية)');
                  setState(() => _selectedLanguage = 'العربية (السعودية)');
                  AppLanguage.instance.setLanguage('ar');
                  Navigator.pop(ctx);
                }),
                const SizedBox(height: 10),
                _langOption('🇺🇸', 'English (US)', 'Switch app language to English', !AppLanguage.instance.isArabic, () {
                  setSheetState(() => _selectedLanguage = 'English (US)');
                  setState(() => _selectedLanguage = 'English (US)');
                  AppLanguage.instance.setLanguage('en');
                  Navigator.pop(ctx);
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _langOption(String flag, String title, String subtitle, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? kPrimary : kBorder, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? kPrimaryDark : kText)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: kSub)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: kPrimary, size: 22),
          ],
        ),
      ),
    );
  }

  // ── 4. Merchant Registration Sheet ──
  void _showMerchantSheet() {
    final storeName = TextEditingController();
    final crNumber = TextEditingController();
    final storeCategory = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
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
                  Icon(Icons.storefront_rounded, color: kPrimary, size: 26),
                  SizedBox(width: 10),
                  Text('الانضمام كتاجر في تموين بلس 🏪', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                ],
              ),
              const SizedBox(height: 8),
              const Text('وسع مبيعاتك ووصل منتجاتك لألاف العملاء يومياً بخطوات بسيطة.', style: TextStyle(color: kSub, fontSize: 12)),
              const SizedBox(height: 20),
              _buildTextField('اسم المتجر / الشركة', storeName, Icons.store_outlined),
              const SizedBox(height: 14),
              _buildTextField('رقم السجل التجاري', crNumber, Icons.badge_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 14),
              _buildTextField('نشاط المتجر (مثال: مواد غذائية، خضار وفواكه...)', storeCategory, Icons.category_outlined),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (storeName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال اسم المتجر'), backgroundColor: kRed),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    _showSuccessDialog('تم استلام طلبك بنجاح!', 'سيقوم فريق تموين بلس لمبيعات الجملة والتجار بالتواصل معك خلال 24 ساعة لإنشاء متجرك.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('إرسال طلب الانضمام 🚀', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 5. Contact Us Sheet ──
  void _showContactUsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const Text('تواصل مع خدمة العملاء 💬', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
              const SizedBox(height: 6),
              const Text('نحن هنا لخدمتك على مدار الساعة طوال أيام الأسبوع', style: TextStyle(color: kSub, fontSize: 12)),
              const SizedBox(height: 20),
              _contactCard(Icons.chat_bubble_outline_rounded, 'واتساب الدعم الفني', 'رد سريع وخدمة فورية', const Color(0xFF25D366), () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري فتح المحادثة على واتساب... 📱')));
              }),
              const SizedBox(height: 10),
              _contactCard(Icons.phone_in_talk_rounded, 'الرقم المجاني الموحد', '920001234', kPrimary, () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري الاتصال بـ 920001234... 📞')));
              }),
              const SizedBox(height: 10),
              _contactCard(Icons.email_outlined, 'البريد الإلكتروني للشكاوى', 'support@tamween.sa', kOrange, () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ البريد الإلكتروني support@tamween.sa')));
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard(IconData icon, String title, String sub, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kText)),
                  Text(sub, style: const TextStyle(fontSize: 12, color: kSub)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kSub),
          ],
        ),
      ),
    );
  }

  // ── 6. FAQ Sheet ──
  void _showFaqSheet() {
    final faqs = [
      {'q': 'ما هي طرق الدفع المتاحة في تطبيق تموين بلس؟', 'a': 'نوفر جميع طرق الدفع الآمنة: مدى (Mada)، أبل باي (Apple Pay)، الفيزا والماستركارد، بالإضافة إلى الدفع نقداً عند الاستلام.'},
      {'q': 'كم يستغرق توصيل الطلب؟', 'a': 'يتم توصيل الطلبات خلال 30 إلى 60 دقيقة عبر أسطول مناديبنا المعتمدين في مدينتك.'},
      {'q': 'كيف يمكنني الاستفادة من المحفظة والكاش باك؟', 'a': 'يضاف الكاش باك فوراً لمحفظتك بعد كل طلب ناجح، ويمكنك استخدامه لخصم قيمة طلبك القادم بالكامل أو جزء منه.'},
      {'q': 'ما هي سياسة الإرجاع أو الاستبدال؟', 'a': 'يمكنك إرجاع أي منتج تالف أو غير مطابق للمواصفات خلال 24 ساعة من استلام الطلب واسترداد قيمته للمحفظة فوراً.'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: controller,
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
                    Icon(Icons.quiz_rounded, color: kPrimary, size: 26),
                    SizedBox(width: 8),
                    Text('الأسئلة الشائعة 💡', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                  ],
                ),
                const SizedBox(height: 16),
                ...faqs.map((faq) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(faq['q']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kText)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(faq['a']!, style: const TextStyle(fontSize: 12, color: kSub, height: 1.5)),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 7. About App Sheet ──
  void _showAboutAppSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 45, height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimary.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(Icons.shopping_basket_rounded, size: 48, color: kPrimary),
              ),
              const SizedBox(height: 12),
              const Text('تموين بلس (Tamween Plus)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kPrimaryDark)),
              const Text('إصدار التطبيق v1.0.0 (Build 102)', style: TextStyle(fontSize: 12, color: kSub)),
              const SizedBox(height: 16),
              const Text(
                'تموين بلس هو منصتك الأولى للتسوق السريع وشراء التموينات والمقاضي المنزلية والتجارية في المملكة العربية السعودية بأفضل الأسعار وأسرع توصيل.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: kText, height: 1.6),
              ),
              const SizedBox(height: 20),
              const Text('جميع الحقوق محفوظة © 2026 تموين بلس', style: TextStyle(fontSize: 11, color: kSub)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ── 8. Terms & Conditions Sheet ──
  void _showTermsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: controller,
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
                    Icon(Icons.gavel_rounded, color: kPrimary, size: 26),
                    SizedBox(width: 8),
                    Text('الشروط والأحكام وسياسة الخصوصية 📜', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kText)),
                  ],
                ),
                const SizedBox(height: 16),
                _termsSection('1. مقدمة واستخدام الخدمة', 'باستخدامك لتطبيق تموين بلس، فإنك توافق على الالتزام بكافة الشروط والأحكام الموضحة هنا. تلتزم المنصة بتوفير خدمات التسوق والتوصيل بأعلى معايير الجودة.'),
                _termsSection('2. حماية البيانات والخصوصية', 'نحن نحترم خصوصيتك بالكامل. جميع بيانات العميل (الاسم، الجوال، العنوان) يتم تشفيرها وتأمينها وفقاً لأنظمة حماية البيانات الشخصية في المملكة.'),
                _termsSection('3. الدفع والاسترداد', 'في حال إلغاء الطلب قبل الشحن، يتم إعادة المبالغ المدفوعة فوراً لرصيد المحفظة الخاص بك لاستخدامها لاحقاً.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _termsSection(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryDark)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(fontSize: 12, color: kSub, height: 1.6)),
        ],
      ),
    );
  }

  // ── 9. Wallet Sheet ──
  void _showWalletSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPrimary, kPrimaryDark],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: kPrimary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('رصيد المحفظة الحالي', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 6),
                    const Text('150.00 ر.س', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('شحن المحفظة عبر بطاقة مدى أو أبل باي 💳'), backgroundColor: kGreen));
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('شحن المحفظة الان'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('آخر العمليات', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText)),
              const SizedBox(height: 10),
              _transactionRow('كاش باك طلب رقم #1024', '+25.00 ر.س', 'اليوم 02:15 م', kGreen),
              _transactionRow('خصم طلب تموين #1019', '-45.00 ر.س', 'أمس 08:30 م', kRed),
              _transactionRow('شحن محفظة عبر Mada', '+170.00 ر.س', '24 يوليو 2026', kPrimary),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionRow(String title, String amount, String date, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(amount.startsWith('+') ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kText)),
                Text(date, style: const TextStyle(fontSize: 11, color: kSub)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  // Helper dialog
  void _showSuccessDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          icon: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: kGreen, size: 40),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          content: Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: kSub, fontSize: 13, height: 1.5)),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                ),
                child: const Text('حسناً', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {TextInputType? keyboardType, bool isPassword = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimary, size: 20),
        filled: true,
        fillColor: kBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kPrimary, width: 1.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: ListView(
        children: [
          // ── Premium Profile Header ──
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              bottom: 24, right: 20, left: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C9A7), kPrimary, kPrimaryDark],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // Top bar icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لا توجد إشعارات جديدة حالياً 🔔'), backgroundColor: kPrimary),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('حساب موثق', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Avatar
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم فتح معارض الصور لتحديث الصورة الشخصية 📸')),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _userName.isNotEmpty ? _userName[0] : 'م',
                            style: const TextStyle(color: kPrimaryDark, fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  _userName,
                  style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$_userEmail • $_userPhone',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Stats Row (Clickable!)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('12', 'الطلبات', Icons.shopping_bag_outlined, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('انتقل إلى تبويب "الطلبات" لعرض السجل بالكامل 📦')));
                      }),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _statItem('2', 'العناوين', Icons.location_on_outlined, () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => AddressSelectorSheet(
                            currentAddress: _currentAddress,
                            onSelectAddress: (addr) => setState(() => _currentAddress = addr),
                          ),
                        );
                      }),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _statItem('150 ر.س', 'المحفظة', Icons.account_balance_wallet_outlined, _showWalletSheet),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Main Section ──
          _section([
            _row(Icons.person_outlined, 'بيانات الحساب', 'تعديل بيانات الحساب والاسم', showChevron: true, onTap: _showEditProfileSheet),
            _row(Icons.lock_outlined, 'تعديل كلمة المرور', 'أنشئ كلمة مرور جديدة للحماية', showChevron: true, onTap: _showChangePasswordSheet),
            _row(Icons.language_rounded, 'لغة التطبيق', _selectedLanguage, showChevron: true, leading: _flagIcon(), onTap: _showLanguageSheet),
            _row(Icons.store_outlined, 'سجل كتاجر في التطبيق', 'أنشئ متجرك في تموين بلس', showChevron: true, onTap: _showMerchantSheet),
          ]),

          const SizedBox(height: 14),

          // ── Settings Section ──
          _section([
            _row(
              Icons.notifications_outlined,
              'استقبال الإشعارات',
              'تفعيل الإشعارات للطلبات والعروض الحصرية',
              trailing: Switch(
                value: _notifEnabled,
                onChanged: (v) {
                  setState(() => _notifEnabled = v);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(v ? 'تم تفعيل الإشعارات 🔔' : 'تم تعطيل الإشعارات 🔕')),
                  );
                },
                activeThumbColor: kPrimary,
              ),
            ),
          ]),

          const SizedBox(height: 14),

          // ── Support Section ──
          _section([
            _row(Icons.headset_mic_outlined, 'تواصل معنا', 'الاقتراحات والشكاوى', showChevron: true, onTap: _showContactUsSheet),
            _row(Icons.help_outline_rounded, 'الأسئلة الشائعة', 'إجابات عن الاستفسارات المتكررة', showChevron: true, onTap: _showFaqSheet),
            _row(Icons.info_outline_rounded, 'عن التطبيق', 'إصدار التطبيق v1.0.0', showChevron: true, onTap: _showAboutAppSheet),
            _row(Icons.shield_outlined, 'الشروط والأحكام', 'سياسة الخصوصية والاستخدام', showChevron: true, onTap: _showTermsSheet),
          ]),

          const SizedBox(height: 24),

          // ── Logout Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.power_settings_new_rounded, size: 22),
              label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 54),
                elevation: 3,
                shadowColor: const Color(0x55FF3B30),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _section(List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(children: rows),
    );
  }

  Widget _row(
    IconData icon,
    String title,
    String subtitle, {
    bool showChevron = false,
    Widget? trailing,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
        ),
        child: Row(
          children: [
            if (showChevron) const Icon(Icons.chevron_left_rounded, color: Color(0xFFC7C7CC), size: 20)
            else if (trailing != null) trailing
            else const SizedBox(width: 20),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kText)),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle, style: const TextStyle(color: kSub, fontSize: 11)),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            leading ?? Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: kPrimaryBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: kPrimary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flagIcon() => Container(
    width: 38, height: 38,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Center(
        child: Text(_selectedLanguage.contains('العربية') ? '🇸🇦' : '🇺🇸', style: const TextStyle(fontSize: 22)),
      ),
    ),
  );
}

