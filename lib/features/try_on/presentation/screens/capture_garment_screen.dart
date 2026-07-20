import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/features/try_on/presentation/widgets/category_selector.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../preferences/data/preferences_local_source.dart';

/// نوع الملبس اللي المستخدم بيختاره قبل التصوير
enum GarmentCategory {
  tops,
  bottoms,
  onePieces;

  String get apiValue => switch (this) {
        GarmentCategory.tops => 'tops',
        GarmentCategory.bottoms => 'bottoms',
        GarmentCategory.onePieces => 'one-pieces',
      };
}

class CaptureGarmentScreen extends ConsumerStatefulWidget {
  const CaptureGarmentScreen({super.key});

  @override
  ConsumerState<CaptureGarmentScreen> createState() =>
      _CaptureGarmentScreenState();
}

class _CaptureGarmentScreenState extends ConsumerState<CaptureGarmentScreen> {
  File? _selectedFile;
  GarmentCategory _selectedCategory = GarmentCategory.tops;

  @override
  void initState() {
    super.initState();
    // نستخدم addPostFrameCallback عشان ref يكون جاهز
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedCategory = ref.read(defaultCategoryProvider);
      setState(() {
        _selectedCategory = switch (savedCategory) {
          'bottoms' => GarmentCategory.bottoms,
          'one-pieces' => GarmentCategory.onePieces,
          _ => GarmentCategory.tops,
        };
      });
    });
  }

  Future<void> _pick(bool fromCamera) async {
    final imageService = ref.read(imageServiceProvider);
    try {
      final file = fromCamera
          ? await imageService.pickFromCamera()
          : await imageService.pickFromGallery();
      if (file != null && mounted) {
        setState(() => _selectedFile = file);
      }
    } on ImageProcessingException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('camera_gallery_error'))),
        );
      }
    }
  }

  void _continue() {
    if (_selectedFile == null) return;
    context.push(
      AppRoutes.generating,
      extra: {
        'file': _selectedFile,
        'category': _selectedCategory.apiValue,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(title: Text(context.tr('capture_garment_title'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              // اختيار نوع الملبس
              CategorySelector(
                selected: _selectedCategory,
                onSelect: (cat) => setState(() => _selectedCategory = cat),
              ).animate().fadeIn().slideY(begin: 0.05, end: 0),

              const SizedBox(height: AppSpacing.md),

              // منطقة الصورة
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.inkElevated,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _selectedFile != null
                      ? SizedBox.expand(
                          child: Image.file(
                            _selectedFile!,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedCategory == GarmentCategory.tops
                                  ? Icons.checkroom_rounded
                                  : _selectedCategory == GarmentCategory.bottoms
                                      ? Icons.accessibility_new_rounded
                                      : Icons.dry_cleaning_rounded,
                              size: 64,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                              child: Text(
                                _selectedCategory == GarmentCategory.tops
                                    ? context.tr('capture_hint_tops')
                                    : _selectedCategory == GarmentCategory.bottoms
                                        ? context.tr('capture_hint_bottoms')
                                        : context.tr('capture_hint_one_pieces'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // الأزرار
              if (_selectedFile == null)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pick(false),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(context.tr('gallery')),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _pick(true),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt_rounded,
                                      size: 20, color: AppColors.textPrimary),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.tr('camera'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _selectedFile = null),
                        child: Text(context.tr('retake_photo')),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        label: 'شوفها عليا',
                        icon: Icons.auto_awesome_rounded,
                        onPressed: _continue,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}