# هيكل المشروع - قبلتي Qiblati

## 📁 البنية الكاملة للمشروع

```
qibla_finder/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart          # ثوابت التطبيق (AdMob IDs، إحداثيات الكعبة)
│   │   │   └── arabic_strings.dart         # جميع النصوص العربية
│   │   ├── theme/
│   │   │   └── app_theme.dart              # تصميم التطبيق (فاتح/داكن)
│   │   └── utils/
│   │       └── qibla_calculator.dart       # حسابات اتجاه القبلة
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── location_data.dart          # نموذج بيانات الموقع
│   │   │   ├── qibla_data.dart             # نموذج بيانات القبلة
│   │   │   └── prayer_time_data.dart       # نموذج أوقات الصلاة
│   │   └── services/
│   │       ├── location_service.dart       # خدمة GPS والموقع
│   │       ├── compass_service.dart        # خدمة البوصلة
│   │       ├── prayer_times_service.dart   # خدمة أوقات الصلاة
│   │       └── admob_service.dart          # خدمة AdMob
│   │
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── location_provider.dart      # مزود الموقع (Riverpod)
│   │   │   ├── compass_provider.dart       # مزود البوصلة
│   │   │   ├── qibla_provider.dart         # مزود القبلة
│   │   │   ├── prayer_times_provider.dart  # مزود أوقات الصلاة
│   │   │   └── theme_provider.dart         # مزود المظهر
│   │   ├── screens/
│   │   │   ├── home_screen.dart            # الشاشة الرئيسية
│   │   │   ├── prayer_times_screen.dart    # شاشة أوقات الصلاة
│   │   │   ├── settings_screen.dart        # شاشة الإعدادات
│   │   │   ├── privacy_policy_screen.dart  # شاشة سياسة الخصوصية
│   │   │   └── help_screen.dart            # شاشة المساعدة
│   │   └── widgets/
│   │       └── qibla_compass.dart          # ويدجت البوصلة المخصصة
│   │
│   └── main.dart                            # نقطة بداية التطبيق
│
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── kotlin/com/example/qibla_finder/
│   │   │   │   └── MainActivity.kt
│   │   │   └── AndroidManifest.xml         # الأذونات ومعرّف AdMob
│   │   └── build.gradle                    # إعدادات البناء
│   ├── build.gradle                        # إعدادات Gradle الرئيسية
│   └── settings.gradle                     # إعدادات المشروع
│
├── ios/
│   ├── Runner/
│   │   ├── AppDelegate.swift               # تهيئة AdMob لـ iOS
│   │   └── Info.plist                      # الأذونات ومعرّف AdMob
│   └── Podfile                             # تبعيات CocoaPods
│
├── assets/
│   ├── fonts/
│   │   ├── Cairo-Regular.ttf              # (يجب تنزيلها)
│   │   ├── Cairo-Bold.ttf                 # (يجب تنزيلها)
│   │   ├── Cairo-SemiBold.ttf             # (يجب تنزيلها)
│   │   └── README.md                      # تعليمات تنزيل الخطوط
│   ├── images/                            # (للصور المستقبلية)
│   └── lottie/                            # (للرسوم المتحركة)
│
├── pubspec.yaml                           # التبعيات والموارد
├── README.md                              # دليل المشروع
├── SETUP_GUIDE.md                         # دليل الإعداد الشامل
├── PROJECT_STRUCTURE.md                   # هذا الملف
└── .gitignore                             # الملفات المستثناة من Git

```

## 🎯 وصف المكونات الرئيسية

### 1. Core Layer (الطبقة الأساسية)

#### Constants (الثوابت)
- **app_constants.dart**: يحتوي على:
  - إحداثيات الكعبة (21.4225, 39.8262)
  - معرّفات AdMob (Banner, Interstitial, Rewarded)
  - إعدادات التطبيق (تكرار الإعلانات، مدة الإعلانات المجانية)
  - مفاتيح SharedPreferences

- **arabic_strings.dart**: جميع النصوص العربية المستخدمة في التطبيق:
  - نصوص الشاشة الرئيسية
  - رسائل الأذونات
  - تعليمات المعايرة
  - أوقات الصلاة
  - رسائل الأخطاء
  - سياسة الخصوصية
  - نصوص المساعدة

#### Theme (المظهر)
- **app_theme.dart**: تصميم التطبيق:
  - المظهر الفاتح (Light Theme)
  - المظهر الداكن (Dark Theme)
  - الألوان الرئيسية والثانوية
  - تنسيقات الأزرار والبطاقات
  - خط Cairo العربي

#### Utils (الأدوات)
- **qibla_calculator.dart**: حسابات اتجاه القبلة:
  - حساب الاتجاه من موقع المستخدم إلى الكعبة
  - حساب المسافة إلى الكعبة
  - التحقق من مواجهة القبلة
  - تطبيع الزوايا

### 2. Data Layer (طبقة البيانات)

#### Models (النماذج)
- **location_data.dart**: بيانات الموقع
  - خطوط العرض والطول
  - الارتفاع والدقة
  - المدينة والبلد
  - الوقت

- **qibla_data.dart**: بيانات القبلة
  - اتجاه القبلة (0-360°)
  - المسافة إلى الكعبة
  - اتجاه البوصلة الحالي
  - حالة مواجهة القبلة

- **prayer_time_data.dart**: أوقات الصلاة
  - الفجر، الشروق، الظهر، العصر، المغرب، العشاء
  - تنسيق الأوقات
  - الحصول على الصلاة القادمة

#### Services (الخدمات)
- **location_service.dart**: خدمة تحديد الموقع
  - طلب أذونات الموقع
  - الحصول على الموقع الحالي (يتطلب GPS مفعّل)
  - تدفق الموقع المستمر
  - التحقق من تفعيل GPS
  - رسائل خطأ واضحة عند تعطيل GPS
  - تحويل الإحداثيات إلى عنوان (Geocoding)

- **compass_service.dart**: خدمة البوصلة
  - قراءة اتجاه البوصلة
  - تدفق القراءات المستمر
  - التحقق من توفر البوصلة

- **prayer_times_service.dart**: خدمة أوقات الصلاة
  - حساب الأوقات بناءً على الموقع
  - استخدام طريقة أم القرى
  - الحصول على الصلاة الحالية والقادمة

- **admob_service.dart**: خدمة الإعلانات
  - تحميل إعلانات Banner
  - تحميل وعرض إعلانات Interstitial (كل 5 استخدامات)
  - تحميل وعرض إعلانات Rewarded (لإزالة الإعلانات 24 ساعة)
  - كتم صوت إعلانات الفيديو
  - إدارة حالة الإعلانات المجانية

### 3. Presentation Layer (طبقة العرض)

#### Providers (مزودات Riverpod)
- **location_provider.dart**: إدارة حالة الموقع
- **compass_provider.dart**: إدارة حالة البوصلة
- **qibla_provider.dart**: دمج الموقع والبوصلة لحساب القبلة
- **prayer_times_provider.dart**: إدارة أوقات الصلاة
- **theme_provider.dart**: إدارة المظهر (فاتح/داكن/نظام)

#### Screens (الشاشات)
- **home_screen.dart**: الشاشة الرئيسية
  - عرض البوصلة
  - معلومات الموقع
  - زر المعايرة
  - إعلان Banner في الأسفل
  - إعلان Interstitial دوري

- **prayer_times_screen.dart**: شاشة أوقات الصلاة
  - عرض جميع الأوقات
  - تمييز الصلاة القادمة
  - التاريخ الهجري والميلادي

- **settings_screen.dart**: شاشة الإعدادات
  - اختيار المظهر (فاتح/داكن/نظام)
  - إزالة الإعلانات (Rewarded Ad)
  - روابط المساعدة والخصوصية
  - معلومات التطبيق

- **privacy_policy_screen.dart**: سياسة الخصوصية كاملة

- **help_screen.dart**: شاشة المساعدة والإرشادات

#### Widgets (الواجهات المخصصة)
- **qibla_compass.dart**: البوصلة المخصصة
  - رسم دائرة البوصلة
  - عرض الاتجاهات الأساسية (ش، ج، ق، غ)
  - سهم يشير إلى القبلة
  - تغيير اللون عند مواجهة القبلة
  - درجات البوصلة وعلامات الاتجاه

### 4. Platform-Specific (إعدادات المنصات)

#### Android
- **AndroidManifest.xml**:
  - أذونات (INTERNET, LOCATION)
  - معرّف AdMob App
  - اسم التطبيق

- **build.gradle**:
  - إعدادات SDK (minSdk: 21, targetSdk: 34)
  - تبعيات Kotlin

#### iOS
- **Info.plist**:
  - وصف أذونات الموقع بالعربية
  - معرّف AdMob App
  - إعدادات الأمان للإعلانات

- **AppDelegate.swift**:
  - تهيئة AdMob SDK

- **Podfile**:
  - إصدار iOS المستهدف (12.0+)

## 🔄 تدفق البيانات

```
المستخدم
   ↓
الشاشة الرئيسية (home_screen.dart)
   ↓
Providers (qibla_provider.dart)
   ↓
Services (location_service, compass_service)
   ↓
Native APIs (GPS, Magnetometer)
   ↓
حسابات (qibla_calculator.dart)
   ↓
UI Update (qibla_compass.dart)
```

## 📦 التبعيات الرئيسية

### حالة (State Management)
- `flutter_riverpod`: إدارة الحالة

### الموقع والبوصلة
- `geolocator`: تحديد الموقع GPS
- `flutter_compass`: قراءة البوصلة
- `geocoding`: تحويل الإحداثيات إلى عناوين
- `permission_handler`: إدارة الأذونات

### أوقات الصلاة
- `adhan`: حساب أوقات الصلاة

### الإعلانات
- `google_mobile_ads`: AdMob

### واجهة المستخدم
- `flutter_svg`: رسومات SVG
- `lottie`: رسوم متحركة (للاستخدام المستقبلي)

### أخرى
- `shared_preferences`: حفظ الإعدادات
- `url_launcher`: فتح الروابط
- `intl`: تنسيق التواريخ والأوقات
- `vector_math`: عمليات حسابية

## 🎨 نمط الكود

### Clean Architecture
التطبيق يتبع مبادئ Clean Architecture:
- **Presentation**: الواجهات والحالة
- **Data**: البيانات والخدمات
- **Core**: الأدوات والثوابت المشتركة

### SOLID Principles
- **Single Responsibility**: كل ملف له مسؤولية واحدة
- **Open/Closed**: سهل التوسع بدون تعديل
- **Dependency Inversion**: استخدام Providers للفصل

### Best Practices
- استخدام `const` للعناصر الثابتة
- تسميات واضحة بالعربية في التعليقات
- معالجة الأخطاء في جميع الخدمات
- Null Safety كامل
- RTL Support كامل

## 🚀 النقاط المميزة

1. **دقة عالية** في حساب اتجاه القبلة باستخدام GPS
2. **تجربة مستخدم ممتازة** مع مؤشرات بصرية وصوتية
3. **أداء محسّن** مع تحميل مسبق للإعلانات
4. **تحذيرات واضحة** لضمان دقة الاتجاه (يتطلب GPS دائمًا)
5. **دعم كامل للعربية** مع RTL
6. **إعلانات غير مزعجة** ومُحسّنة
7. **كود نظيف وقابل للصيانة**
8. **متوافق مع سياسات Google Play**

---

**تم إنشاء هذا الهيكل بواسطة Claude AI 🤖**
