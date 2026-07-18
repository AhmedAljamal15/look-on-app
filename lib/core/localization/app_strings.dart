import 'package:flutter/material.dart';

/// Central translation table for the whole app.
///
/// Usage:
///   context.tr('capture_garment_title')
///
/// For code that has no BuildContext (services, providers, thrown
/// exceptions), use [AppLocalizations.t] directly — it always reflects
/// the currently-selected language via [AppLocalizations.currentLocaleCode].
class AppLocalizations {
  AppLocalizations._();

  /// Kept in sync by LocaleController whenever the user switches language,
  /// so non-widget code (services, Failure/Exception messages) can still
  /// resolve the correct translation without a BuildContext.
  static String currentLocaleCode = 'ar';

  static String t(String key) {
    final map = _values[currentLocaleCode] ?? _values['ar']!;
    return map[key] ?? _values['ar']?[key] ?? key;
  }

  static String of(BuildContext context, String key) {
    final code =
        Localizations.maybeLocaleOf(context)?.languageCode ?? currentLocaleCode;
    final map = _values[code] ?? _values['ar']!;
    return map[key] ?? _values['ar']?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _values = {
    'ar': {
      // ---------- عام ----------
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'retry': 'أعد المحاولة',
      'done': 'تم',
      'skip': 'تخطي',
      'next': 'التالي',
      'settings': 'الإعدادات',
      'gallery': 'المعرض',
      'camera': 'الكاميرا',
      'retake_photo': 'التقط مجدداً',

      // ---------- الالتقاط: الملبس ----------
      'camera_gallery_error': 'تعذّر فتح الكاميرا أو المعرض',
      'capture_garment_title': 'التقط صورة الملبس',
      'capture_garment_hint':
          'ضع الملبس أمامك أو على شماعة، والتقط صورته من الأمام في إضاءة جيدة',
      'try_it_on_me': 'جرّبها عليّ',

      // تلميحات الفئات المختلفة
      'capture_hint_tops':
          'صوّر القميص أو الجاكيت من الأمام بإضاءة جيدة',
      'capture_hint_bottoms':
          'صوّر البنطلون أو التنورة من الأمام بإضاءة جيدة',
      'capture_hint_one_pieces':
          'صوّر الفستان أو البدلة كاملاً من الأمام بإضاءة جيدة',

      // فئات الملابس (للشيبس وورقة الاختيار)
      'category_tops': 'علوي',
      'category_bottoms': 'سفلي',
      'category_one_pieces': 'قطعة كاملة',
      'category_tops_sub': 'قمصان',
      'category_bottoms_sub': 'بناطيل',
      'category_one_pieces_sub': 'فساتين',

      // فئات كاملة للعنوان الفرعي في البروفايل
      'category_tops_full': 'علوي (قمصان)',
      'category_bottoms_full': 'سفلي (بناطيل)',
      'category_one_pieces_full': 'قطعة كاملة (فساتين)',

      // ---------- شاشة التوليد ----------
      'generating_msg_1': 'جارٍ تحليل صورة الملبس...',
      'generating_msg_2': 'جارٍ إزالة الخلفية من صورتك...',
      'generating_msg_3': 'جارٍ احتساب مقاساتك...',
      'generating_msg_4': 'جارٍ تركيب الملبس عليك...',
      'generating_msg_5': 'جارٍ ضبط الألوان والإضاءة...',
      'generating_msg_6': 'اقتربنا من الانتهاء، يُرجى الانتظار...',
      'generating_msg_7': 'جارٍ إضافة اللمسات الأخيرة...',
      'generating_msg_8': 'سيظهر خلال لحظات...',
      'generating_time_label': 'الوقت: {time}',
      'generating_seconds': '{n} ثانية',
      'generating_minutes': '{m} دقيقة{extra}',
      'generating_minutes_extra': ' و{s} ثانية',
      'generating_ai_note':
          'يعمل الذكاء الاصطناعي على صورتك، قد تستغرق العملية من دقيقة إلى ثلاث دقائق',
      'generating_slow_note':
          'إذا كان الإنترنت بطيئاً قد يستغرق وقتاً أطول، شكراً لصبرك 🙏',

      // ---------- الجلسة / الأخطاء العامة ----------
      'no_session_error': 'لا توجد جلسة مستخدم حتى الآن',
      'need_profile_photo_first': 'يجب عليك التقاط صورتك الشخصية أولاً',

      // ---------- المحاولات السابقة ----------
      'history_title': 'المحاولات السابقة',
      'history_fetch_error': 'تعذّر تحميل المحاولات السابقة',
      'history_empty_title': 'لا توجد محاولات بعد',
      'history_empty_subtitle':
          'كل ملبس تجرّبه سيُحفظ هنا لترجع إليه متى شئت',
      'capture_first_shirt': 'جرّب أول ملبس',
      'delete_attempt_title': 'حذف هذه المحاولة؟',
      'delete_attempt_body': 'لن تتمكن من استعادتها بعد الحذف',
      'recent_history_empty': 'لا توجد محاولات بعد. جرّب أول ملبس!',

      // فلاتر السجل
      'filter_all': 'الكل',
      'filter_favorites': 'المفضلة',
      'favorites_empty_title': 'لا توجد عناصر في المفضلة بعد',
      'favorites_empty_subtitle':
          'اضغط على القلب في أي نتيجة لحفظها هنا',

      // ---------- صورة البروفايل ----------
      'profile_photo_title': 'صورتك الشخصية',
      'profile_photo_hint': 'صورة واضحة بإضاءة جيدة وأنت واقف بشكل طبيعي',
      'photo_ready': 'صورتك جاهزة',
      'need_photo_first': 'نحتاج إلى صورتك أولاً',
      'photo_usage_ready': 'ستُستخدم في كل تجربة افتراضية',
      'photo_usage_once': 'ستلتقطها مرة واحدة فقط',

      // ---------- البروفايل / الحساب ----------
      'account': 'حسابك',
      'member_since': 'عضو منذ {date}',
      'total_attempts': 'إجمالي المحاولات',
      'this_month': 'هذا الشهر',
      'updated': 'محدّثة',
      'not_set_yet': 'لم يُضبط بعد',
      'my_measurements_title': 'مقاساتك',
      'saved': 'محفوظة',
      'all_attempts': 'كل المحاولات',
      'attempts_count': '{n} محاولة',
      'month_1': 'يناير', 'month_2': 'فبراير', 'month_3': 'مارس',
      'month_4': 'أبريل', 'month_5': 'مايو', 'month_6': 'يونيو',
      'month_7': 'يوليو', 'month_8': 'أغسطس', 'month_9': 'سبتمبر',
      'month_10': 'أكتوبر', 'month_11': 'نوفمبر', 'month_12': 'ديسمبر',

      // ---------- تفضيلات المستخدم ----------
      'gender_label': 'الجنس',
      'gender_male': 'رجل',
      'gender_female': 'امرأة',
      'preferred_garment': 'الملبس المفضل',
      'select_gender_title': 'اختر الجنس',

      // ---------- الإعدادات ----------
      'change_profile_photo': 'تغيير صورتك الشخصية',
      'add_profile_photo': 'إضافة صورة شخصية',
      'language': 'اللغة',
      'language_arabic': 'العربية',
      'language_english': 'English',

      // ---------- نتيجة القياس ----------
      'image_load_error': 'تعذّر تحميل الصورة',
      'share_message': 'شاهد كيف يبدو هذا الملبس عليّ! 👕✨\n{url}',
      'another_shirt': 'ملبس آخر',

      // ---------- الرئيسية ----------
      'capture_now_title': 'التقط صورة ملبس الآن',
      'capture_now_subtitle': 'وشاهد كيف يبدو عليك في ثوانٍ',
      'recent_attempts': 'آخر المحاولات',
      'view_all': 'عرض الكل',

      // ---------- الواجهة العامة ----------
      'no_internet_banner': 'لا يوجد اتصال بالإنترنت',
      'splash_tagline': 'شاهد نفسك في الملبس قبل شرائه',

      // ---------- الأونبوردنج ----------
      'onboard_1_title': 'في المتجر، التقط صورة الملبس فقط',
      'onboard_1_subtitle':
          'لا حاجة لأخذ الملبس ودخول غرفة القياس، فقط التقط صورة لما يعجبك بالكاميرا.',
      'onboard_2_title': 'الذكاء الاصطناعي يريك كيف تبدو به',
      'onboard_2_subtitle':
          'في ثوانٍ، سترى نفسك ترتدي الملبس قبل شرائه.',
      'onboard_3_title': 'وقتك أثمن من الانتظار',
      'onboard_3_subtitle': 'اتخذ قرارك بسرعة، ووفّر وقتك أثناء التسوق.',
      'lets_start': 'لنبدأ',

      // ---------- رسالة الترحيب ----------
      'welcome_to': 'مرحباً بك في {appName}',
      'welcome_body':
          'التقط صورة أي ملبس في أي متجر، وشاهد كيف يبدو عليك فوراً بالذكاء الاصطناعي — دون الحاجة إلى غرفة القياس.',
      'consent_text':
          'أوافق على شروط الاستخدام وسياسة الخصوصية، وعلى حفظ صورتي لاستخدام ميزة التجربة الافتراضية',
      'agree': 'أوافق',
      'welcome_bullet_1': 'التقط صورة أي ملبس في أي متجر في ثوانٍ',
      'welcome_bullet_2': 'الذكاء الاصطناعي يريك كيف يبدو عليك فوراً',
      'welcome_bullet_3':
          'جميع محاولاتك محفوظة يمكنك مراجعتها في أي وقت',
      'lets_go': 'هيا بنا! 🎉',
      'enjoy_app': 'استمتع بالتطبيق',

      // ---------- المقاسات ----------
      'measurements_saved_snack': 'تم حفظ مقاساتك ✨',
      'measurements_hint':
          'تساعد مقاساتك الذكاءَ الاصطناعيَّ على إنتاج نتيجة أدق وأقرب إلى مظهرك الحقيقي',
      'preferred_size': 'المقاس المفضل',
      'measurements_label': 'القياسات',
      'height': 'الطول',
      'weight': 'الوزن',
      'chest': 'محيط الصدر',
      'waist': 'محيط الخصر',
      'shoulder': 'عرض الكتف',
      'unit_cm': 'سم',
      'unit_in': 'بوصة',
      'unit_kg': 'كجم',
      'unit_lb': 'رطل',
      'saved_check': 'تم الحفظ ✓',
      'save_measurements': 'حفظ المقاسات',
      'skip_for_now': 'تخطي الآن',

      // ---------- أخطاء الخدمات (تُعرض عن طريق AppLocalizations.t) ----------
      'auth_session_create_failed': 'فشل إنشاء جلسة المستخدم',
      'auth_login_failed': 'فشل تسجيل الدخول',
      'auth_no_user': 'لا يوجد مستخدم مسجّل دخوله حالياً',
      'image_unclear_error':
          'هذه الصورة غير واضحة بما يكفي، حاول الالتقاط مجدداً.',
      'image_temp_save_error': 'حدث خطأ أثناء الحفظ المؤقت للصورة.',
      'image_process_error':
          'حدث خطأ أثناء معالجة الصورة، حاول مجدداً.',
      'storage_upload_failed': 'فشل رفع الصورة: {error}',
      'ai_no_image_returned': 'لم يعُد النموذج بصورة، حاول مجدداً',
      'ai_no_url_in_response': 'لا يوجد رابط صورة في الاستجابة',
      'ai_server_connect_failed': 'فشل الاتصال بخادم الذكاء الاصطناعي',
      'ai_auth_error':
          'توجد مشكلة في إعدادات الخدمة، حاول مجدداً بعد قليل',
      'ai_rate_limit':
          'الخدمة مشغولة حالياً، انتظر قليلاً وأعد المحاولة',
      'ai_bad_image':
          'الصورة غير واضحة بما يكفي للذكاء الاصطناعي، جرّب صورة أخرى بإضاءة أفضل',
      'ai_timeout': 'استغرق الطلب وقتاً أطول من المتوقع، حاول مجدداً',
      'ai_no_internet': 'تحقق من اتصالك بالإنترنت وأعد المحاولة',
      'ai_unexpected_error': 'حدث خطأ غير متوقع، حاول مجدداً',
      'network_failure': 'تحقق من اتصالك بالإنترنت وأعد المحاولة.',
      'server_failure': 'حدث خطأ من جهتنا، حاول مجدداً بعد قليل.',
      'auth_failure_msg': 'حدث خطأ أثناء تسجيل الدخول.',
      'storage_failure_msg': 'تعذّر رفع الصورة أو تحميلها.',
      'tryon_gen_failure': 'تعذّر إنتاج المعاينة، جرّب صورة أخرى.',
      'permission_failure': 'نحتاج إلى إذن الكاميرا أو المعرض للمتابعة.',
      'cache_failure': 'تعذّر حفظ البيانات على الجهاز.',
      'unknown_failure': 'حدث خطأ غير متوقع.',
      'splash_session_error':
          'تعذّر بدء الجلسة، تحقق من اتصالك بالإنترنت.',
      'daily_limit_reached':
          'لقد وصلت إلى الحد الأقصى للمحاولات المجانية اليومية ({n})، حاول مجدداً غداً',
      'attempts_remaining_today': 'تبقّى لك {n} محاولات اليوم',
    },
    'en': {
      // ---------- General ----------
      'cancel': 'Cancel',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'retry': 'Try again',
      'done': 'Done',
      'skip': 'Skip',
      'next': 'Next',
      'settings': 'Settings',
      'gallery': 'Gallery',
      'camera': 'Camera',
      'retake_photo': 'Retake photo',

      // ---------- Capture garment ----------
      'camera_gallery_error': "Couldn't open the camera or gallery",
      'capture_garment_title': 'Snap the garment',
      'capture_garment_hint':
          'Lay the garment flat or on a hanger, and shoot it head-on in good light',
      'try_it_on_me': 'Try it on me',

      // Per-category hints
      'capture_hint_tops':
          'Snap the shirt or jacket from the front in good light',
      'capture_hint_bottoms':
          'Snap the trousers or skirt from the front in good light',
      'capture_hint_one_pieces':
          'Snap the dress or jumpsuit in full from the front in good light',

      // Garment category chips / sheet options
      'category_tops': 'Tops',
      'category_bottoms': 'Bottoms',
      'category_one_pieces': 'Full pieces',
      'category_tops_sub': 'Shirts',
      'category_bottoms_sub': 'Trousers',
      'category_one_pieces_sub': 'Dresses',

      // Full labels for profile subtitle
      'category_tops_full': 'Tops (shirts)',
      'category_bottoms_full': 'Bottoms (trousers)',
      'category_one_pieces_full': 'Full pieces (dresses)',

      // ---------- Generating screen ----------
      'generating_msg_1': 'Analyzing the garment photo...',
      'generating_msg_2': 'Removing the background from your photo...',
      'generating_msg_3': 'Calculating your measurements...',
      'generating_msg_4': 'Fitting the garment on you...',
      'generating_msg_5': 'Adjusting colors and lighting...',
      'generating_msg_6': 'Almost done, hang on...',
      'generating_msg_7': 'Adding the final touches...',
      'generating_msg_8': 'Coming up in seconds...',
      'generating_time_label': 'Time: {time}',
      'generating_seconds': '{n}s',
      'generating_minutes': '{m}m{extra}',
      'generating_minutes_extra': ' {s}s',
      'generating_ai_note':
          'The AI is working on your photo, this can take 1 to 3 minutes',
      'generating_slow_note':
          "If your internet is slow it might take longer, hang tight 🙏",

      // ---------- Session / general errors ----------
      'no_session_error': 'No active user session yet',
      'need_profile_photo_first': 'You need to take your profile photo first',

      // ---------- History ----------
      'history_title': 'Past attempts',
      'history_fetch_error': "Couldn't load your past attempts",
      'history_empty_title': 'No attempts yet',
      'history_empty_subtitle':
          "Every garment you try on gets saved here so you can come back to it",
      'capture_first_shirt': 'Try on your first garment',
      'delete_attempt_title': 'Delete this attempt?',
      'delete_attempt_body': "You won't be able to get it back after deleting",
      'recent_history_empty': 'No attempts yet. Try on your first garment!',

      // History filters
      'filter_all': 'All',
      'filter_favorites': 'Favorites',
      'favorites_empty_title': 'No favorites yet',
      'favorites_empty_subtitle':
          'Tap the heart on any result to save it here',

      // ---------- Profile photo ----------
      'profile_photo_title': 'Your profile photo',
      'profile_photo_hint': 'A clear photo, good lighting, standing naturally',
      'photo_ready': 'Your photo is ready',
      'need_photo_first': "We need your photo first",
      'photo_usage_ready': "We'll use it for every virtual try-on",
      'photo_usage_once': "You'll only need to take it once",

      // ---------- Account ----------
      'account': 'Your account',
      'member_since': 'Member since {date}',
      'total_attempts': 'Total try-ons',
      'this_month': 'This month',
      'updated': 'Updated',
      'not_set_yet': 'Not set yet',
      'my_measurements_title': 'Your measurements',
      'saved': 'Saved',
      'all_attempts': 'All attempts',
      'attempts_count': '{n} attempts',
      'month_1': 'January',
      'month_2': 'February',
      'month_3': 'March',
      'month_4': 'April',
      'month_5': 'May',
      'month_6': 'June',
      'month_7': 'July',
      'month_8': 'August',
      'month_9': 'September',
      'month_10': 'October',
      'month_11': 'November',
      'month_12': 'December',

      // ---------- User preferences ----------
      'gender_label': 'Gender',
      'gender_male': 'Male',
      'gender_female': 'Female',
      'preferred_garment': 'Preferred garment',
      'select_gender_title': 'Select gender',

      // ---------- Settings ----------
      'change_profile_photo': 'Change your profile photo',
      'add_profile_photo': 'Add a profile photo',
      'language': 'Language',
      'language_arabic': 'العربية',
      'language_english': 'English',

      // ---------- Result screen ----------
      'image_load_error': "Couldn't load the image",
      'share_message': 'Check out how this garment looks on me! 👕✨\n{url}',
      'another_shirt': 'Another garment',

      // ---------- Home ----------
      'capture_now_title': 'Try on a garment now',
      'capture_now_subtitle': 'See how it looks on you in seconds',
      'recent_attempts': 'Recent attempts',
      'view_all': 'View all',

      // ---------- General UI ----------
      'no_internet_banner': 'No internet connection',
      'splash_tagline': 'See yourself in the outfit before you buy it',

      // ---------- Onboarding ----------
      'onboard_1_title': 'At the store, just snap the garment',
      'onboard_1_subtitle':
          "No need to grab the outfit and go into the fitting room — just snap a photo of anything you like.",
      'onboard_2_title': 'AI shows you how it looks on you',
      'onboard_2_subtitle':
          "In seconds, you'll see yourself wearing the garment before you buy it.",
      'onboard_3_title': 'Your time matters more than the queue',
      'onboard_3_subtitle': 'Decide fast, and save time while you shop.',
      'lets_start': "Let's start",

      // ---------- Welcome dialog ----------
      'welcome_to': 'Welcome to {appName}',
      'welcome_body':
          'Snap any garment at any store, and see how it looks on you instantly with AI — no fitting room needed.',
      'consent_text':
          "I agree to the Terms of Use and Privacy Policy, and that my photo will be saved to use the virtual try-on feature",
      'agree': 'Agree',
      'welcome_bullet_1': 'Snap any garment at any store in seconds',
      'welcome_bullet_2': 'AI shows you how it looks on you instantly',
      'welcome_bullet_3':
          'All your attempts are saved for you to revisit anytime',
      'lets_go': "Let's go! 🎉",
      'enjoy_app': 'Enjoy the app',

      // ---------- Measurements ----------
      'measurements_saved_snack': 'Your measurements were saved ✨',
      'measurements_hint':
          'Your measurements help the AI produce a more accurate result closer to your real shape',
      'preferred_size': 'Preferred size',
      'measurements_label': 'Measurements',
      'height': 'Height',
      'weight': 'Weight',
      'chest': 'Chest',
      'waist': 'Waist',
      'shoulder': 'Shoulder width',
      'unit_cm': 'cm',
      'unit_in': 'in',
      'unit_kg': 'kg',
      'unit_lb': 'lb',
      'saved_check': 'Saved ✓',
      'save_measurements': 'Save measurements',
      'skip_for_now': 'Skip for now',

      // ---------- Service errors ----------
      'auth_session_create_failed': 'Failed to create a user session',
      'auth_login_failed': 'Sign-in failed',
      'auth_no_user': 'No user is currently signed in',
      'image_unclear_error': "This photo isn't clear enough, try again.",
      'image_temp_save_error':
          'There was a problem saving the photo temporarily.',
      'image_process_error':
          'There was a problem processing the photo, try again.',
      'storage_upload_failed': 'Failed to upload the photo: {error}',
      'ai_no_image_returned': "The model didn't return an image, try again",
      'ai_no_url_in_response': 'No image URL in the response',
      'ai_server_connect_failed': 'Failed to connect to the AI server',
      'ai_auth_error':
          'There is a service configuration issue, try again shortly',
      'ai_rate_limit':
          'The service is busy right now, wait a bit and try again',
      'ai_bad_image':
          "The photo isn't clear enough for the AI, try a photo with better lighting",
      'ai_timeout': 'The request took longer than expected, try again',
      'ai_no_internet': 'Check your internet connection and try again',
      'ai_unexpected_error': 'An unexpected error occurred, try again',
      'network_failure': 'Check your internet connection and try again.',
      'server_failure': 'Something went wrong on our end, try again shortly.',
      'auth_failure_msg': 'There was a problem signing in.',
      'storage_failure_msg': "Couldn't upload or load the photo.",
      'tryon_gen_failure': "Couldn't generate the preview, try another photo.",
      'permission_failure': 'We need camera or gallery permission to continue.',
      'cache_failure': "Couldn't save data on the device.",
      'unknown_failure': 'An unexpected error occurred.',
      'splash_session_error':
          "Couldn't start the session, check your internet connection.",
      'daily_limit_reached':
          "You've reached today's free limit ({n} attempts), try again tomorrow",
      'attempts_remaining_today': '{n} attempts left today',
    },
  };
}

extension AppLocalizationsX on BuildContext {
  String tr(String key) => AppLocalizations.of(this, key);
}
