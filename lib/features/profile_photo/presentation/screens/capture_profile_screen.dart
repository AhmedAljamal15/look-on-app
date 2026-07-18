import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/profile_photo_providers.dart';
import '../../../../core/localization/app_strings.dart';

/// One-time (or re-takeable) capture of the user's base photo, used as
/// the "person" input for every future try-on. Framed with guidance copy
/// so the captured photo actually works well with the AI model
/// (front-facing, good lighting, plain background).
class CaptureProfileScreen extends ConsumerStatefulWidget {
  const CaptureProfileScreen({super.key});

  @override
  ConsumerState<CaptureProfileScreen> createState() =>
      _CaptureProfileScreenState();
}

class _CaptureProfileScreenState extends ConsumerState<CaptureProfileScreen> {
  File? _selectedFile;

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
            .showSnackBar(SnackBar(content: Text(AppLocalizations.t(e.message))));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('camera_gallery_error'))),
        );
      }
    }
  }

  Future<void> _confirm() async {
    if (_selectedFile == null) return;
    await ref
        .read(profilePhotoCaptureProvider.notifier)
        .savePhoto(_selectedFile!);

    final state = ref.read(profilePhotoCaptureProvider);
    if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.t(state.error.toString()))),
        );
      }
      return;
    }
    if (mounted && state.value != null) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(profilePhotoCaptureProvider);
    final isSaving = captureState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(title: Text(context.tr('profile_photo_title'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
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
                      ? Image.file(_selectedFile!, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 64,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                              child: Text(
                                context.tr('profile_photo_hint'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
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
                          gradient: AppColors.violetGoldGradient,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violet.withValues(alpha: 0.35),
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
                                        ?.copyWith(color: AppColors.textPrimary),
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
                        onPressed: isSaving
                            ? null
                            : () => setState(() => _selectedFile = null),
                        child: Text(context.tr('retake_photo')),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        label: context.tr('confirm'),
                        isLoading: isSaving,
                        onPressed: _confirm,
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
