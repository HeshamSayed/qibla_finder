# دليل الإعداد الكامل - قبلتي Qiblati

## 🚀 الخطوات السريعة للبدء

### 1️⃣ تثبيت Flutter
إذا لم يكن لديك Flutter مثبتًا:

```bash
# تحقق من وجود Flutter
flutter --version

# إذا لم يكن مثبتًا، قم بتنزيله من:
# https://docs.flutter.dev/get-started/install
```

### 2️⃣ استنساخ المشروع وتثبيت التبعيات

```bash
# الانتقال إلى مجلد المشروع
cd qibla_finder

# تثبيت جميع التبعيات
flutter pub get
```

### 3️⃣ تنزيل الخطوط العربية

1. افتح الرابط: https://fonts.google.com/specimen/Cairo
2. انقر على "Download family"
3. فك ضغط الملف المحمل
4. انسخ هذه الملفات إلى مجلد `assets/fonts/`:
   - `Cairo-Regular.ttf`
   - `Cairo-Bold.ttf`
   - `Cairo-SemiBold.ttf`

### 4️⃣ إعداد AdMob

#### الحصول على معرّفات AdMob:

1. **إنشاء حساب AdMob**:
   - اذهب إلى: https://admob.google.com/
   - سجل الدخول بحساب Google
   - أنشئ حسابًا جديدًا

2. **إضافة تطبيق**:
   - انقر على "Apps" من القائمة
   - انقر على "Add App"
   - اختر المنصة (Android أو iOS)
   - أدخل اسم التطبيق: "قبلتي - Qiblati"
   - احصل على **App ID**

3. **إنشاء وحدات الإعلانات**:

   **أ. Banner Ad:**
   - انقر على "Ad units"
   - انقر على "Add ad unit"
   - اختر "Banner"
   - أدخل اسم: "Qiblati Banner"
   - احصل على **Banner Ad Unit ID**

   **ب. Interstitial Ad:**
   - نفس الخطوات، لكن اختر "Interstitial"
   - أدخل اسم: "Qiblati Interstitial"
   - احصل على **Interstitial Ad Unit ID**

   **ج. Rewarded Ad:**
   - نفس الخطوات، لكن اختر "Rewarded"
   - أدخل اسم: "Qiblati Rewarded"
   - احصل على **Rewarded Ad Unit ID**

4. **كرر العملية لـ iOS** (إذا كنت تنشر على iOS أيضًا)

#### تحديث معرّفات AdMob في الكود:

**ملف 1: `lib/core/constants/app_constants.dart`**

```dart
// AdMob IDs - استبدل بمعرّفاتك الحقيقية
static const String androidBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // من AdMob Console
static const String iosBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // من AdMob Console
static const String androidInterstitialId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String iosInterstitialId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String androidRewardedId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String iosRewardedId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
```

**ملف 2: `ios/Runner/Info.plist`** (للـ iOS App ID)

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

**ملاحظة**: معرّف App ID للـ Android موجود بالفعل في `android/app/src/main/AndroidManifest.xml` وهو:
```
ca-app-pub-6976864649919972~8399903229
```

### 5️⃣ اختبار التطبيق

```bash
# التشغيل على Android
flutter run

# أو على iOS
flutter run -d ios

# أو على محاكي/جهاز محدد
flutter devices  # لعرض الأجهزة المتاحة
flutter run -d <device-id>
```

## 🏗️ بناء التطبيق للإنتاج

### Android

#### 1. إنشاء Keystore (لتوقيع التطبيق):

```bash
keytool -genkey -v -keystore ~/qiblati-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias qiblati
```

احفظ كلمة المرور والمعلومات في مكان آمن!

#### 2. إنشاء ملف `android/key.properties`:

```properties
storePassword=<كلمة المرور>
keyPassword=<كلمة المرور>
keyAlias=qiblati
storeFile=<مسار الـ keystore>
```

#### 3. تعديل `android/app/build.gradle`:

أضف قبل `android {`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

داخل `android {` أضف:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

#### 4. بناء APK:

```bash
flutter build apk --release
```

الملف الناتج: `build/app/outputs/flutter-apk/app-release.apk`

#### 5. بناء App Bundle (للنشر على Google Play):

```bash
flutter build appbundle --release
```

الملف الناتج: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
# افتح Xcode
open ios/Runner.xcworkspace

# أو قم ببناء من سطر الأوامر
flutter build ios --release
```

## 📱 النشر على Google Play Store

### التحضيرات:

1. **حساب Google Play Console**:
   - اذهب إلى: https://play.google.com/console
   - سجل الدخول وأنشئ حسابًا للمطورين (رسوم لمرة واحدة: $25)

2. **سياسة الخصوصية**:
   - التطبيق يحتوي على سياسة خصوصية مدمجة
   - يجب رفعها أيضًا على موقع ويب (يمكن استخدام GitHub Pages)
   - احفظ محتوى الملف من: `lib/core/constants/arabic_strings.dart` → `privacyPolicyContent`

3. **لقطات الشاشة**:
   - التقط 4-8 لقطات شاشة من التطبيق
   - الأحجام المطلوبة:
     - الهواتف: 1080x1920 أو 1080x2340
     - الأجهزة اللوحية: 1600x2560

4. **أيقونة التطبيق**:
   - حجم 512x512 بكسل
   - صيغة PNG
   - بدون شفافية

### خطوات النشر:

1. **إنشاء تطبيق جديد** في Google Play Console
2. **ملء معلومات التطبيق**:
   - الاسم: قبلتي - Qiblati
   - الوصف المختصر (80 حرف)
   - الوصف الكامل (4000 حرف)
   - التصنيف: التطبيقات الدينية / أدوات
   - العمر المناسب: للجميع

3. **رفع App Bundle**:
   - اذهب إلى "Production" → "Create new release"
   - ارفع ملف `app-release.aab`

4. **إضافة الصور**:
   - الأيقونة
   - لقطات الشاشة
   - (اختياري) صورة مميزة

5. **سياسة المحتوى**:
   - أضف رابط سياسة الخصوصية
   - أجب على الأسئلة حول استخدام البيانات

6. **التسعير والتوزيع**:
   - اختر "مجاني"
   - حدد الدول (جميع الدول)

7. **إرسال للمراجعة**

## 🧪 الاختبار

### اختبار الوظائف الأساسية:

- [ ] تشغيل التطبيق بنجاح
- [ ] طلب أذونات الموقع
- [ ] الحصول على الموقع الحالي
- [ ] عرض اتجاه القبلة بشكل صحيح
- [ ] دوران البوصلة مع حركة الهاتف
- [ ] تغيير اللون عند مواجهة القبلة
- [ ] عرض أوقات الصلاة
- [ ] التبديل بين الوضع المضيء والداكن
- [ ] عرض الإعلانات
- [ ] الوضع بدون اتصال (تشغيل الطيران وإعادة فتح التطبيق)

### اختبار على أجهزة مختلفة:

- اختبر على هاتف Android قديم (API 21+)
- اختبر على هاتف Android حديث
- اختبر في أماكن مختلفة (في الهواء الطلق، داخل المباني)

## 🔧 استكشاف الأخطاء الشائعة

### خطأ: "Unable to load assets"
```bash
flutter clean
flutter pub get
flutter run
```

### خطأ: "MissingPluginException"
```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### البوصلة لا تعمل:
- تأكد من أن الجهاز يحتوي على مستشعر مغناطيسي
- جرب معايرة البوصلة (حركة رقم 8)
- ابتعد عن الأجهزة الإلكترونية

### الإعلانات لا تظهر:
- في وضع الاختبار، استخدم معرّفات اختبار AdMob
- تأكد من تفعيل الإنترنت
- انتظر قليلاً، قد يستغرق تحميل الإعلانات وقتًا

### خطأ في الموقع:
- تأكد من منح أذونات الموقع
- جرب في مكان مفتوح (للحصول على إشارة GPS جيدة)
- أعد تشغيل GPS في الهاتف

## 📞 الدعم

إذا واجهت أي مشاكل:
1. تحقق من ملف README.md
2. راجع الأخطاء في Terminal
3. ابحث في Flutter documentation

## ✅ قائمة التحقق النهائية قبل النشر

- [ ] اختبار التطبيق على عدة أجهزة
- [ ] تحديث معرّفات AdMob الحقيقية
- [ ] إزالة أي `print()` statements غير ضرورية
- [ ] تحديث رقم الإصدار في `pubspec.yaml`
- [ ] إنشاء Keystore للتوقيع
- [ ] بناء App Bundle
- [ ] تحضير لقطات الشاشة والأيقونة
- [ ] كتابة وصف جذاب للتطبيق
- [ ] رفع سياسة الخصوصية على موقع
- [ ] مراجعة جميع النصوص العربية
- [ ] التحقق من عمل RTL بشكل صحيح

---

**بالتوفيق في نشر تطبيقك! 🚀**
