class ArabicStrings {
  // App Name
  static const String appName = 'قبلتي - Qiblati';

  // Main Screen
  static const String qiblaDirection = 'اتجاه القبلة';
  static const String degreeToQibla = 'درجة إلى القبلة';
  static const String yourLocation = 'موقعك الحالي';
  static const String calibrateCompass = 'معايرة البوصلة';
  static const String facingQibla = 'أنت تواجه القبلة';

  // Permissions
  static const String locationPermissionTitle = 'إذن الموقع مطلوب';
  static const String locationPermissionMessage = 'نحتاج إلى الوصول إلى موقعك لحساب اتجاه القبلة بدقة';
  static const String locationPermissionDenied = 'تم رفض إذن الموقع';
  static const String locationPermissionDeniedMessage = 'يرجى تفعيل إذن الموقع من إعدادات التطبيق';
  static const String openSettings = 'فتح الإعدادات';
  static const String cancel = 'إلغاء';

  // Compass Calibration
  static const String calibrationTitle = 'معايرة البوصلة';
  static const String calibrationInstruction = 'قم بتحريك هاتفك في حركة دائرية على شكل رقم 8 لمعايرة البوصلة';
  static const String calibrationStep1 = '١. أمسك الهاتف بشكل مسطح';
  static const String calibrationStep2 = '٢. حرك الهاتف في حركة دائرية';
  static const String calibrationStep3 = '٣. كرر الحركة عدة مرات';
  static const String understood = 'فهمت';

  // Prayer Times
  static const String prayerTimes = 'أوقات الصلاة';
  static const String fajr = 'الفجر';
  static const String sunrise = 'الشروق';
  static const String dhuhr = 'الظهر';
  static const String asr = 'العصر';
  static const String maghrib = 'المغرب';
  static const String isha = 'العشاء';

  // Settings
  static const String settings = 'الإعدادات';
  static const String theme = 'المظهر';
  static const String lightTheme = 'مضيء';
  static const String darkTheme = 'داكن';
  static const String systemTheme = 'النظام';
  static const String about = 'حول التطبيق';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String help = 'المساعدة';
  static const String removeAds = 'إزالة الإعلانات لمدة 24 ساعة';
  static const String watchAd = 'مشاهدة إعلان';

  // Error Messages
  static const String error = 'خطأ';
  static const String locationError = 'خطأ في الحصول على الموقع';
  static const String compassError = 'خطأ في قراءة البوصلة';
  static const String noGpsSignal = 'لا يوجد إشارة GPS';
  static const String gpsDisabled = 'GPS غير مفعّل';
  static const String gpsDisabledMessage = 'يجب تفعيل GPS للحصول على اتجاه دقيق للقبلة.\n\n⚠️ تحذير: استخدام موقع قديم قد يؤدي إلى تحديد اتجاه خاطئ للقبلة!';
  static const String enableGps = 'تفعيل GPS';
  static const String accuracyWarning = 'تنبيه: للحصول على اتجاه دقيق للقبلة، يجب أن يكون GPS مفعّلاً';
  static const String checkInternet = 'يرجى التحقق من اتصال الإنترنت';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String loading = 'جاري التحميل...';

  // Help
  static const String helpTitle = 'كيفية استخدام التطبيق';
  static const String helpStep1 = 'السماح بالوصول إلى موقعك';
  static const String helpStep2 = 'أمسك الهاتف بشكل مسطح';
  static const String helpStep3 = 'قم بمعايرة البوصلة إذا لزم الأمر';
  static const String helpStep4 = 'اتبع السهم للاتجاه نحو القبلة';
  static const String helpStep5 = 'سيتغير اللون إلى الأخضر عند مواجهة القبلة';

  // Privacy Policy
  static const String privacyPolicyTitle = 'سياسة الخصوصية';
  static const String privacyPolicyContent = '''
تطبيق القبلة - سياسة الخصوصية

١. جمع البيانات:
نقوم بجمع موقعك الجغرافي فقط لحساب اتجاه القبلة. لا نقوم بتخزين أو مشاركة هذه البيانات مع أي طرف ثالث.

٢. استخدام البيانات:
- يتم استخدام موقعك لحساب اتجاه القبلة بدقة
- يتم استخدام موقعك لحساب أوقات الصلاة
- لا يتم إرسال بياناتك إلى أي خادم خارجي

٣. الإعلانات:
يستخدم التطبيق Google AdMob لعرض الإعلانات. قد تقوم Google بجمع بيانات مجهولة المصدر لتحسين تجربة الإعلانات.

٤. الأذونات:
- إذن الموقع: مطلوب لحساب اتجاه القبلة وأوقات الصلاة
- الإنترنت: مطلوب لعرض الإعلانات والحصول على البيانات الجغرافية

٥. الأمان:
نحن نلتزم بحماية خصوصيتك. جميع البيانات المستخدمة في التطبيق محلية ولا يتم إرسالها إلى خوادمنا.

٦. الاتصال:
لأي استفسارات بخصوص الخصوصية، يرجى التواصل معنا.

آخر تحديث: 2025
''';

  // About
  static const String aboutContent = '''
قبلتي - Qiblati

تطبيق بسيط ودقيق لإيجاد اتجاه القبلة باستخدام GPS والبوصلة.

المميزات:
✓ حساب دقيق لاتجاه القبلة باستخدام GPS
✓ بوصلة تفاعلية مع مؤشر بصري
✓ عرض موقعك الحالي بالعربية
✓ أوقات الصلاة بناءً على موقعك
✓ دعم الوضع المضيء والداكن
✓ واجهة عربية كاملة
✓ تحذيرات واضحة لضمان الدقة

⚠️ هام: يتطلب التطبيق تفعيل GPS للحصول على اتجاه دقيق للقبلة

الإصدار: 1.0.0

تم التطوير بواسطة: فريق قبلتي
''';

  // Share
  static const String share = 'مشاركة';
  static const String shareMessage = 'جرب تطبيق القبلة - اكتشف اتجاه القبلة بسهولة ودقة';
}
