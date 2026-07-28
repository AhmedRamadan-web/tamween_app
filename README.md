# تموين بلس — Tamween Plus 🛒

> تطبيق iOS / Android احترافي لتوصيل البقالة والتموين، مبني بـ Flutter.

---

## 🗂️ هيكل المشروع

```
tamween-flutter-code/
├── lib/
│   ├── main.dart                          ← نقطة البداية + إعدادات الثيم
│   └── screens/
│       ├── splash_screen.dart             ← شاشة البداية (Animated)
│       ├── login_screen.dart              ← تسجيل الدخول
│       └── main_navigation_screen.dart   ← جميع الشاشات + الـ State
│           ├── HomeTab                   ← الرئيسية
│           ├── StoreTab                  ← المتجر / المنتجات
│           ├── CartTab                   ← سلة التسوق
│           ├── OrdersTab                 ← سجل الطلبات
│           └── ProfileTab                ← الحساب الشخصي
├── assets/
│   ├── fonts/                            ← خط Tajawal
│   └── images/                           ← صور التطبيق
└── pubspec.yaml                          ← التبعيات والإعدادات
```

---

## ✨ المميزات

| الميزة | التفاصيل |
|--------|----------|
| 🌍 اللغة العربية | دعم كامل للغة العربية RTL |
| 🎨 تصميم iOS | Material 3 بتجربة مستخدم iOS أصيلة |
| 🛒 سلة تسوق | إضافة، حذف، تعديل الكمية |
| 🏷️ كود خصم | `Tamween` = خصم 36% |
| 📑 فاتورة | ضريبة 15% + توصيل مجاني فوق 150 ريال |
| 📦 الطلبات | طلبات حالية ومكتملة |
| 👤 الحساب | صفحة بروفايل كاملة |
| 💚 المفضلة | إضافة منتجات للمفضلة |
| ⚡ الأداء | `IndexedStack` لتنقل سريع بين التابات |

---

## 🚀 تشغيل المشروع

### المتطلبات
- Flutter SDK >= 3.0.0
- Xcode (لـ iOS) أو Android Studio (لـ Android)

### خطوات التشغيل

```bash
# 1. تنزيل التبعيات
flutter pub get

# 2. تشغيل على iOS Simulator
flutter run -d ios

# 3. تشغيل على Android
flutter run -d android

# 4. بناء iOS (.ipa)
flutter build ios --release
```

---

## 🎨 نظام الألوان

| اللون | الكود | الاستخدام |
|-------|-------|-----------|
| Teal Primary | `#00BFA5` | الأزرار، الأيقونات النشطة |
| Teal Dark | `#00897B` | التدرجات |
| Teal Light | `#E0F7F5` | الخلفيات الفاتحة |
| Orange | `#FF6B35` | الوحدات، التمييز |
| Background | `#F2F2F7` | خلفية iOS |

---

## 📱 الشاشات

### 1. Splash Screen
- انيميشن Logo مع `ScaleTransition` و`FadeTransition`
- انتقال سلس للـ Login

### 2. Login Screen
- حقول إدخال iOS-style
- زر Login مع loading indicator
- دعم كامل للـ validation

### 3. Home Tab
- بانر عروض تفاعلي
- فئات المنتجات
- قائمة المتاجر

### 4. Store Tab
- فلتر المنتجات بالفئة
- زرار + / - مباشر من القائمة
- قلب للمفضلة

### 5. Cart Tab
- عرض المنتجات مع الكمية
- كود الخصم `Tamween`
- فاتورة مفصلة (ضريبة + توصيل + خصم)
- زر إتمام الطلب

### 6. Orders Tab
- طلبات حالية / مكتملة
- تاريخ ورقم الطلب

### 7. Profile Tab
- بيانات المستخدم
- إعدادات الحساب

---

## 🔧 التقنيات المستخدمة

- **Flutter 3.x** — Cross-platform (iOS + Android)
- **Dart** — لغة البرمجة
- **Material 3** — نظام التصميم
- **Tajawal Font** — خط عربي احترافي
- **StatefulWidget** — إدارة الحالة
- **IndexedStack** — تنقل التابات بدون إعادة بناء

---

## 👨‍💻 المطوّر

**تموين بلس** — مشروع تطرق درسي
تطبيق iOS/Android للتموين والبقالة
