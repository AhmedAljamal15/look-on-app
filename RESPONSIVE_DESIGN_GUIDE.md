# Responsive Design Implementation Guide

This document explains how to make your Flutter app fully responsive using the new responsive utilities.

## 📱 Device Breakpoints

```dart
- Mobile:  < 600px  (iPhone, Android phones)
- Tablet:  600-1024px (iPad Mini, Android tablets)
- Desktop: > 1024px (iPad Pro, Desktop)
```

---

## 🚀 Quick Start Examples

### 1. **Using Responsive Dimensions**

Instead of hard-coded sizes, use responsive dimensions:

```dart
// ❌ BEFORE (Hard-coded)
SizedBox(
  width: 100,
  height: 120,
  child: Image.network(imageUrl),
)

// ✅ AFTER (Responsive)
ResponsiveSizedBox(
  mobileWidth: 100,
  tabletWidth: 150,
  desktopWidth: 200,
  mobileHeight: 120,
  tabletHeight: 180,
  desktopHeight: 240,
  child: Image.network(imageUrl),
)
```

### 2. **Using Responsive Padding/Spacing**

```dart
// ❌ BEFORE (Fixed padding)
Padding(
  padding: const EdgeInsets.all(AppSpacing.lg), // Always 24px
  child: child,
)

// ✅ AFTER (Responsive padding)
ResponsivePadding(
  mobileHorizontal: 16,
  mobileVertical: 12,
  tabletHorizontal: 24,
  tabletVertical: 16,
  desktopHorizontal: 32,
  desktopVertical: 20,
  child: child,
)
```

### 3. **Using Responsive Grid View**

```dart
// ❌ BEFORE (Fixed columns)
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Always 2 columns
  ),
  itemBuilder: (context, index) => ...,
)

// ✅ AFTER (Responsive columns)
ResponsiveGridView(
  itemCount: items.length,
  mobileColumns: 2,
  tabletColumns: 3,
  desktopColumns: 4,
  mobileChildHeight: 200,
  tabletChildHeight: 250,
  desktopChildHeight: 300,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 4. **Using Responsive Font Sizes**

```dart
// ❌ BEFORE (Fixed font size)
Text(
  'Hello World',
  style: Theme.of(context).textTheme.headlineSmall, // Always 24px
)

// ✅ AFTER (Responsive font size)
ResponsiveText(
  'Hello World',
  mobileFontSize: 20,
  tabletFontSize: 24,
  desktopFontSize: 28,
  fontWeight: FontWeight.bold,
)
```

### 5. **Using Build Context Extensions**

```dart
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';

// Get screen information
double width = context.screenWidth;
double height = context.screenHeight;
bool isMobile = context.isMobile;
bool isTablet = context.isTablet;
bool isLandscape = context.isLandscape;

// Get responsive values
double mobileFontSize = context.responsiveFontSize(
  mobile: 14,
  tablet: 16,
  desktop: 18,
);

double padding = context.responsiveDimension(
  mobile: 12,
  tablet: 16,
  desktop: 20,
);
```

---

## 🎯 Refactoring Existing Screens

### Before: `language_select_screen.dart`

```dart
_LanguageCard(
  label: 'العربية',
  onTap: () => onChoose(const Locale('ar')),
).animate().fadeIn(delay: 200.ms),

// LanguageCard widget has fixed sizes:
SizedBox(
  height: 200, // Hard-coded!
  child: ...,
)
```

### After: Make it Responsive

```dart
// In _LanguageCard widget:
ResponsiveSizedBox(
  mobileHeight: 150,
  tabletHeight: 200,
  desktopHeight: 250,
  child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        context.responsiveDimension(
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
      ),
    ),
    child: ...,
  ),
).animate().fadeIn(delay: 200.ms),
```

---

## 📋 Common Patterns to Fix

### Pattern 1: Fixed Image Sizes

```dart
// ❌ BEFORE
SizedBox(
  width: 100,
  height: 100,
  child: Image.network(imageUrl),
)

// ✅ AFTER
ResponsiveSizedBox(
  mobileWidth: 80,
  tabletWidth: 120,
  desktopWidth: 150,
  mobileHeight: 80,
  tabletHeight: 120,
  desktopHeight: 150,
  child: Image.network(imageUrl, fit: BoxFit.cover),
)
```

### Pattern 2: Fixed Button Sizes

```dart
// ❌ BEFORE
SizedBox(
  width: 200,
  height: 48,
  child: ElevatedButton(...),
)

// ✅ AFTER
ResponsiveSizedBox(
  mobileWidth: 150,
  tabletWidth: 200,
  desktopWidth: 250,
  mobileHeight: 44,
  tabletHeight: 48,
  desktopHeight: 56,
  child: ElevatedButton(...),
)
```

### Pattern 3: Fixed Grid Layouts

```dart
// ❌ BEFORE
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
  ),
  itemBuilder: ...,
)

// ✅ AFTER
ResponsiveGridView(
  itemCount: items.length,
  mobileColumns: 2,
  tabletColumns: 3,
  desktopColumns: 4,
  mainAxisSpacing: context.responsiveGap(
    mobile: 12,
    tablet: 16,
    desktop: 20,
  ),
  crossAxisSpacing: context.responsiveGap(
    mobile: 12,
    tablet: 16,
    desktop: 20,
  ),
  itemBuilder: (context, index) => ...,
)
```

### Pattern 4: Conditional Layouts

```dart
// ❌ BEFORE (No responsive layouts)
Column(
  children: [
    Image.network(imageUrl),
    SizedBox(height: 16),
    Text('Description'),
  ],
)

// ✅ AFTER (Responsive layout that changes based on device)
ResponsiveLayout(
  mobile: Column(
    children: [
      Image.network(imageUrl),
      const SizedBox(height: 16),
      Text('Description'),
    ],
  ),
  tablet: Row(
    children: [
      Expanded(
        child: Image.network(imageUrl),
      ),
      const SizedBox(width: 24),
      Expanded(
        child: Text('Description'),
      ),
    ],
  ),
  desktop: Row(
    children: [
      Expanded(
        flex: 1,
        child: Image.network(imageUrl),
      ),
      const SizedBox(width: 32),
      Expanded(
        flex: 1,
        child: Text('Description'),
      ),
    ],
  ),
)
```

---

## 🛠️ Migration Checklist

Go through each screen and apply these fixes:

### Step 1: Import Responsive Extensions

```dart
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/core/widgets/responsive_widgets.dart';
```

### Step 2: Fix Fixed Sizes

- [ ] Replace `SizedBox(width: X, height: Y)` with `ResponsiveSizedBox`
- [ ] Replace fixed `width: 100` with `responsiveDimension`
- [ ] Replace fixed `height: 100` with `responsiveDimension`

### Step 3: Fix Fixed Padding/Margins

- [ ] Replace `EdgeInsets.all(24)` with `context.responsivePadding`
- [ ] Replace `SizedBox(height: 16)` with `SizedBox(height: context.responsiveGap(...))`

### Step 4: Fix Font Sizes

- [ ] Replace fixed font sizes in `TextStyle` with responsive values
- [ ] Use `ResponsiveText` for better control

### Step 5: Fix Grid/List Layouts

- [ ] Replace `GridView` with `ResponsiveGridView`
- [ ] Adjust columns based on device type

### Step 6: Test on Different Devices

- [ ] Test on mobile (375px width)
- [ ] Test on tablet (768px width)
- [ ] Test on landscape orientation
- [ ] Test with keyboard visible

---

## 📊 Screens to Update (Priority Order)

1. **`language_select_screen.dart`** - Has many fixed sizes
2. **`home_screen.dart`** - Grid/list layouts
3. **`capture_garment_screen.dart`** - Fixed image sizes
4. **`capture_profile_screen.dart`** - Fixed dimensions
5. **`generating_screen.dart`** - Fixed sizes
6. **All cards and widgets** - Use responsive components

---

## 🔍 Common Issues and Fixes

### Issue 1: Text Overflow on Small Screens

```dart
// ✅ SOLUTION: Use ResponsiveText with maxLines
ResponsiveText(
  'Long text',
  mobileFontSize: 12,
  tabletFontSize: 14,
  desktopFontSize: 16,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Issue 2: Buttons Too Small/Large

```dart
// ✅ SOLUTION: Use ResponsiveSizedBox for buttons
ResponsiveSizedBox(
  mobileWidth: context.screenWidth - 32, // Full width minus padding
  mobileHeight: 44,
  tabletWidth: 250,
  tabletHeight: 48,
  desktopWidth: 300,
  desktopHeight: 52,
  child: ElevatedButton(...),
)
```

### Issue 3: Images Not Scaling

```dart
// ✅ SOLUTION: Use Expanded with ResponsiveSizedBox
ResponsiveExpanded(
  child: ResponsiveSizedBox(
    mobileHeight: 200,
    tabletHeight: 300,
    desktopHeight: 400,
    child: Image.network(imageUrl, fit: BoxFit.cover),
  ),
)
```

### Issue 4: Keyboard Overlap

```dart
// ✅ SOLUTION: Use viewInsets to avoid keyboard
SingleChildScrollView(
  child: Padding(
    padding: EdgeInsets.only(
      bottom: context.keyboardHeight + 16,
    ),
    child: ...,
  ),
)
```

---

## 📝 Best Practices

1. **Always use context extensions** instead of hard-coded values
2. **Test on multiple devices** (real devices if possible)
3. **Use SafeArea** for notches and safe areas
4. **Test in landscape** orientation
5. **Consider tablet-specific layouts** for better UX
6. **Use maxWidth constraints** for web/desktop
7. **Scale images appropriately** using `fit: BoxFit.cover`
8. **Test with system font scaling** enabled
9. **Use ConstrainedBox** to set max widths on desktop
10. **Consider touch targets** (min 48x48 on mobile)

---

## 🧪 Testing Responsiveness

### In VS Code Terminal:

```bash
# Run on specific device
flutter run -d <device-id>

# Run with different screen sizes
flutter run --device-id=<id> --web-port=8080

# Profile responsiveness
flutter run --profile
```

### Test Scenarios:

- ✅ Portrait mode on mobile (375x667)
- ✅ Landscape mode on mobile (667x375)
- ✅ iPad portrait (768x1024)
- ✅ iPad landscape (1024x768)
- ✅ Desktop window resize
- ✅ With system font scaling 1.3x
- ✅ With keyboard visible
- ✅ With notch/safe area

---

## 📚 API Reference

### Context Extensions

```dart
// Dimensions
context.screenWidth
context.screenHeight
context.deviceType // DeviceType.mobile, .tablet, .desktop
context.isMobile
context.isTablet
context.isDesktop

// Orientation
context.isPortrait
context.isLandscape

// Safe area
context.devicePadding
context.viewInsets
context.keyboardHeight

// Responsive values
context.responsiveDimension(mobile: 12, tablet: 16, desktop: 20)
context.responsiveFontSize(mobile: 14, tablet: 16, desktop: 18)
context.responsivePadding(mobile: 12, tablet: 16)
context.responsiveSymmetricPadding(horizontalMobile: 16, verticalMobile: 12)
context.responsiveGap(mobile: 12, tablet: 16)
```

### Widgets

- `ResponsiveContainer` - Scales padding/styling
- `ResponsiveGridView` - Adaptive columns
- `ResponsiveRow` - Row/Column switcher
- `ResponsiveSizedBox` - Scales width/height
- `ResponsiveExpanded` - Constrained expansion
- `ResponsivePadding` - Adaptive padding
- `ResponsiveText` - Scales font size
- `ResponsiveAppBar` - Hides/shows elements
- `ResponsiveLayout` - Widget switcher

---

## 📞 Need Help?

Check examples in the responsive_widgets.dart and responsive_extensions.dart files!

---

**Last Updated:** 2026-07-07
