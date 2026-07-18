# FitSnap — تطبيق تجربة الملابس بالـ AI

تطبيق Flutter كامل: المستخدم يصوّر أي قميص في أي محل، والـ AI بيوريله شكله عليه فورًا — من غير ما يدخل غرفة القياس.

---

## 📁 هيكلة المشروع

```
lib/
├── core/                          # كل حاجة مشتركة بين الفيتشرز
│   ├── constants/                 # ثوابت التطبيق (أسماء collections, limits...)
│   ├── errors/                    # Failure (للـ UI) + Exception (للـ data layer)
│   ├── providers/                 # DI الأساسي (auth/storage/AI services)
│   ├── router/                    # go_router + منطق الـ redirect
│   ├── services/                  # Auth, Storage, AI, Image (Firebase wrappers)
│   ├── theme/                     # ألوان، خطوط، spacing، الـ ThemeData كامل
│   └── widgets/                   # عناصر UI مشتركة (أزرار، error/empty states)
│
├── features/
│   ├── onboarding/                # شاشات التعريف بالتطبيق (3 صفحات)
│   ├── home/                      # الشاشة الرئيسية
│   ├── profile_photo/             # تصوير وحفظ صورة المستخدم (مرة واحدة)
│   ├── try_on/                    # تصوير القميص + شاشة "بنركّب عليك"
│   ├── result/                    # عرض نتيجة الـ AI
│   ├── history/                   # كل المحاولات السابقة
│   └── settings/                  # الإعدادات
│
└── main.dart                      # نقطة الدخول

functions/                         # Firebase Cloud Functions (TypeScript)
└── src/index.ts                   # الدالة اللي بتكلم fal.ai (AI try-on)
```

كل فيتشر مقسّم لـ `presentation` (شاشات + widgets) / `application` (Riverpod providers) / `data` (repositories) / `domain` (الـ models) — مفصولين عشان لو غيرت الـ backend أو الـ AI provider بكرة، مش هتلمس شاشة واحدة.

---

## 🧠 إزاي شغال الـ AI Try-On (المعمارية اللي اتفقنا عليها)

```
المستخدم يصوّر القميص
        │
        ▼
  رفع الصورة على Firebase Storage
        │
        ▼
  استدعاء Cloud Function (generateTryOn)
        │
        ▼
  الـ Function بتكلم fal.ai (موديل IDM-VTON)
        │
        ▼
  ترجع رابط الصورة الناتجة
        │
        ▼
  تتسجل في Firestore (history) وتتعرض للمستخدم
```

**ليه الـ Cloud Function في النص ومش الـ app بيكلم fal.ai على طول؟**
عشان API key بتاع fal.ai متسربش جوه التطبيق نفسه (أي حد يقدر يفك الـ APK ويلاقيه). الـ Function هي المكان الوحيد اللي فيه المفتاح.

---

## ⚙️ خطوات التشغيل

### 1. تثبيت الـ dependencies

```bash
flutter pub get
```

### 2. ربط Firebase

```bash
# لو مش متثبت
dart pub global activate flutterfire_cli

# من جوه فولدر المشروع
flutterfire configure
```

ده هيعمل ملف `lib/firebase_options.dart` تلقائي. بعدها رجّع السطرين دول في `lib/main.dart`:

```dart
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// ...
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

في Firebase Console، فعّل:
- **Authentication → Sign-in method → Anonymous** ✅ (هو ده أساس فكرة "بدون تسجيل دخول")
- **Firestore Database** (Production mode)
- **Storage**

### 3. نشر الـ Firestore/Storage rules

```bash
firebase deploy --only firestore:rules,storage
```

### 4. إعداد الـ AI (fal.ai)

1. اعمل حساب على [fal.ai](https://fal.ai) واخد API key.
2. سجّله كـ secret في Firebase:

```bash
firebase functions:secrets:set FAL_KEY
```

3. ابني وانشر الـ function:

```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

### 5. شغّل التطبيق

```bash
flutter run
```

---

## 🎨 الهوية البصرية

اخترت هوية مش الألوان التقليدية لتطبيقات التسوق (أزرق/بنفسجي مكرر). الفكرة: خلفية **ink** غامقة (زي مراية غرفة قياس بالليل) + لون **coral/terracotta** كأكسنت (بيوحي بخيط الحياكة وشريط القياس). الخط: **Poppins** للعناوين (واثق وهندسي) + **Inter** للنصوص (وضوح عالي).

كل التوكنز (الألوان، الـ spacing، الـ radius) مركزّة في `lib/core/theme/` — تقدر تغيّر اللون الأساسي من مكان واحد (`app_colors.dart`) وهيتغيّر في التطبيق كله.

---

## 🧩 إزاي الـ State Management شغال (Riverpod)

- **Services** (`core/services`): wrappers حول Firebase SDKs، مفيهاش state.
- **Repositories** (`*/data`): بترجع `Either<Failure, T>` (مكتبة `fpdart`) بدل ما ترمي exceptions — يعني أي شاشة لازم تتعامل مع الخطأ بشكل صريح، مفيش مفاجآت.
- **Notifiers** (`*/application`): `AsyncNotifier` بيدير حالة التحميل/الخطأ/النجاح لكل action (حفظ صورة، توليد try-on...).
- **Streams** زي `activeProfilePhotoProvider` و`historyProvider` بيفضلوا "حيين" (مش `autoDispose`) عشان الداتا متتقرأش من جديد كل ما تنقل بين الشاشات.

مثال على flow كامل:
```
الشاشة تستدعي ref.read(tryOnGenerationProvider.notifier).generate(file)
        → الـ Notifier يحول الـ state لـ Loading
        → يكلم TryOnRepository
        → الـ Repository يرفع الصورة + يكلم Cloud Function + يحفظ في Firestore
        → يرجع Either<Failure, TryOnResult>
        → الـ Notifier يحول الـ state لـ Data أو Error
        → الشاشة تستجيب تلقائيًا (تنقل لشاشة النتيجة أو تعرض رسالة خطأ)
```

---

## 📝 حاجات لسه ناقصة عشان الإنتاج (Production checklist)

- [ ] أيقونة التطبيق + splash screen أصلية (دلوقتي بسيطة بـ Icon)
- [ ] صور/Lottie حقيقية بدل الـ placeholders في `assets/`
- [ ] اختبار حقيقي لجودة موديل fal.ai على صور محلات مختلفة (إضاءة، خلفيات)
- [ ] Rate limiting على الـ Cloud Function (منع استخدام مفرط)
- [ ] صفحة "الشروط والأحكام" + توضيح إن الصور بتتحفظ على Firebase
- [ ] اختبار على أجهزة iOS فعلية (خصوصًا الكاميرا والصلاحيات)
- [ ] لو حبيت تربط حساب حقيقي اختياريًا بعدين: أضف Google/Apple Sign-In كـ "ترقية" فوق الـ anonymous auth الحالي (Firebase بيدعم `linkWithCredential` للحفاظ على نفس الـ UID والداتا)

---

## 💰 ملاحظة على التكلفة

كل صورة try-on = استدعاء واحد لموديل fal.ai (مدفوع بالاستخدام). راجع التسعير الحالي على fal.ai قبل الإطلاق وفكر في حد أقصى يومي لكل مستخدم لو حبيت تتحكم في التكلفة.
