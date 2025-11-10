# قبلتي - Qiblati

تطبيق قبلتي هو تطبيق Flutter متكامل لتحديد اتجاه القبلة بدقة باستخدام GPS والبوصلة، مع عرض أوقات الصلاة.

## المميزات

✅ **حساب دقيق لاتجاه القبلة** باستخدام GPS والبوصلة
✅ **بوصلة تفاعلية** مع مؤشرات بصرية وصوتية
✅ **أوقات الصلاة** بناءً على الموقع الحالي
✅ **دعم كامل للغة العربية** مع RTL
✅ **وضع مضيء وداكن**
✅ **تحذيرات واضحة** لضمان دقة اتجاه القبلة
✅ **إعلانات AdMob** مُحسَّنة وغير مزعجة
✅ **معمارية نظيفة** (Clean Architecture)
✅ **إدارة حالة** باستخدام Riverpod

⚠️ **هام**: يتطلب التطبيق تفعيل GPS دائمًا للحصول على اتجاه دقيق للقبلة. لا يستخدم التطبيق مواقع محفوظة لتجنب الأخطاء في تحديد الاتجاه.

## البنية التقنية

```
lib/
├── core/
│   ├── constants/          # الثوابت والنصوص العربية
│   ├── theme/              # تصميم التطبيق (مضيء/داكن)
│   └── utils/              # أدوات حسابية (Qibla Calculator)
├── data/
│   ├── models/             # نماذج البيانات
│   └── services/           # الخدمات (GPS, Compass, Prayer Times, AdMob)
├── presentation/
│   ├── providers/          # Riverpod providers
│   ├── screens/            # الشاشات
│   └── widgets/            # المكونات القابلة لإعادة الاستخدام
└── main.dart               # نقطة بداية التطبيق
```

## المتطلبات

- Flutter SDK 3.0.0 أو أحدث
- Dart 3.0.0 أو أحدث
- Android Studio / VS Code
- حساب AdMob (للإعلانات)

## التثبيت والإعداد

### 1. تثبيت التبعيات

```bash
flutter pub get
```

### 2. تنزيل خطوط Cairo العربية

قم بتنزيل خطوط Cairo من Google Fonts وضعها في مجلد `assets/fonts/`:
- Cairo-Regular.ttf
- Cairo-Bold.ttf
- Cairo-SemiBold.ttf

رابط التنزيل: https://fonts.google.com/specimen/Cairo

### 3. إعداد AdMob

#### معرّفات AdMob الحالية:
- **App ID (Android)**: `ca-app-pub-6976864649919972~8399903229`
- **App ID (iOS)**: يجب الحصول عليه من AdMob Console

#### للحصول على معرّفات إعلانات AdMob:

1. سجّل الدخول إلى [AdMob Console](https://apps.admob.com/)
2. أنشئ تطبيقًا جديدًا أو اختر التطبيق الموجود
3. احصل على معرّفات الإعلانات:
   - Banner Ad Unit ID
   - Interstitial Ad Unit ID
   - Rewarded Ad Unit ID

4. قم بتحديث المعرّفات في ملف `lib/core/constants/app_constants.dart`:

```dart
// استبدل هذه المعرّفات بمعرّفاتك الحقيقية
static const String androidBannerId = 'YOUR_ANDROID_BANNER_ID';
static const String iosBannerId = 'YOUR_IOS_BANNER_ID';
static const String androidInterstitialId = 'YOUR_ANDROID_INTERSTITIAL_ID';
static const String iosInterstitialId = 'YOUR_IOS_INTERSTITIAL_ID';
static const String androidRewardedId = 'YOUR_ANDROID_REWARDED_ID';
static const String iosRewardedId = 'YOUR_IOS_REWARDED_ID';
```

5. قم بتحديث iOS App ID في `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_IOS_APP_ID</string>
```

### 4. إعداد Android

تأكد من أن ملف `android/app/build.gradle` يحتوي على:

```gradle
minSdkVersion 21
targetSdkVersion 34
```

### 5. إعداد iOS

```bash
cd ios
pod install
cd ..
```

## تشغيل التطبيق

### Android
```bash
flutter run
```

### iOS
```bash
flutter run -d ios
```

## بناء التطبيق للإنتاج

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (للنشر على Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## إعدادات AdMob المُطبَّقة

### 1. الإعلانات المستخدمة:
- **Banner Ads**: في أسفل الشاشة الرئيسية
- **Interstitial Ads**: تُعرض كل 5 استخدامات
- **Rewarded Ads**: لإزالة الإعلانات لمدة 24 ساعة

### 2. إعلانات الفيديو الصامتة:
جميع إعلانات الفيديو تُعرض بدون صوت افتراضيًا

### 3. استراتيجية تحميل الإعلانات:
- تحميل مسبق للإعلانات في الخلفية
- عدم عرض إعلانات أثناء معايرة البوصلة
- إدارة ذكية لتكرار الإعلانات

## الأذونات المطلوبة

### Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS (`Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج إلى موقعك لحساب اتجاه القبلة بدقة</string>
```

## الميزات الرئيسية

### 1. حساب اتجاه القبلة
- خوارزمية دقيقة لحساب الاتجاه بناءً على إحداثيات GPS
- استخدام البوصلة للتوجيه في الوقت الفعلي
- مؤشر بصري عند مواجهة القبلة
- اهتزاز خفيف عند الاتجاه الصحيح

### 2. أوقات الصلاة
- حساب دقيق باستخدام مكتبة Adhan
- عرض جميع أوقات الصلاة اليومية
- تمييز الصلاة القادمة
- طريقة حساب أم القرى (Umm al-Qura)

### 3. معايرة البوصلة
- تعليمات واضحة بالعربية
- دليل خطوة بخطوة

### 4. تحذيرات الدقة
- تحذير واضح عند تعطيل GPS
- زر سريع لفتح إعدادات الموقع
- رسائل خطأ مفصلة بالعربية

## النشر على Google Play Store

### متطلبات النشر:

1. **سياسة الخصوصية**:
   - متضمنة في التطبيق (شاشة سياسة الخصوصية)
   - يجب رفعها أيضًا على موقع ويب

2. **الأذونات**:
   - جميع الأذونات المطلوبة لها تفسيرات واضحة

3. **المحتوى**:
   - محتوى عائلي وآمن
   - لا توجد ادعاءات مضللة

4. **الإعلانات**:
   - متوافقة مع سياسات AdMob
   - غير مزعجة للمستخدم

### خطوات النشر:

1. إنشاء حساب على Google Play Console
2. إنشاء تطبيق جديد
3. رفع App Bundle
4. ملء معلومات التطبيق
5. إضافة لقطات شاشة
6. رفع سياسة الخصوصية
7. إرسال للمراجعة

## اختبار التطبيق

### اختبار على أجهزة متعددة:
- اختبار البوصلة على أجهزة مختلفة
- التحقق من دقة حساب القبلة
- اختبار الأذونات
- اختبار الإعلانات

### نصائح للاختبار:
1. استخدم معرّفات اختبار AdMob أثناء التطوير
2. اختبر في مواقع جغرافية مختلفة
3. تأكد من ظهور رسائل الخطأ عند تعطيل GPS
4. اختبر التطبيق في الوضع المضيء والداكن
5. تحقق من دقة اتجاه القبلة في أماكن مختلفة

## استكشاف الأخطاء

### البوصلة لا تعمل:
- تأكد من أن الجهاز يحتوي على مستشعر مغناطيسي
- ابتعد عن الأجهزة الإلكترونية والمعادن
- قم بمعايرة البوصلة

### خطأ في الموقع:
- تأكد من تفعيل GPS
- تحقق من أذونات الموقع
- جرب في مكان مفتوح

### الإعلانات لا تظهر:
- تأكد من صحة معرّفات AdMob
- تحقق من الاتصال بالإنترنت
- معرّفات الاختبار قد لا تعرض إعلانات دائمًا

## الترخيص

هذا المشروع مملوك لك ويمكنك استخدامه بحرية.

## الدعم

للمساعدة أو الأسئلة، يرجى فتح issue في المستودع.

---

تم التطوير بواسطة Claude AI 🤖
