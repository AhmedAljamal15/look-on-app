import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/features/measurements/presentation/widgets/unit_toggle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/measurements_providers.dart';
import '../../domain/measurements.dart';
import '../widgets/measurement_field.dart';
import '../widgets/size_chip_selector.dart';
import '../../../../core/localization/app_strings.dart';

class MeasurementsScreen extends ConsumerStatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  ConsumerState<MeasurementsScreen> createState() =>
      _MeasurementsScreenState();
}

class _MeasurementsScreenState extends ConsumerState<MeasurementsScreen> {
  late Measurements _draft;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(measurementsProvider);
    _draft = existing ?? Measurements(updatedAt: DateTime.now());
  }

  void _update(Measurements Function(Measurements) updater) {
    setState(() {
      _draft = updater(_draft);
      _saved = false;
    });
  }

  Future<void> _save() async {
    await ref.read(measurementsProvider.notifier).save(_draft);
    setState(() => _saved = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('measurements_saved_snack'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCm = _draft.unit == SizeUnit.cm;

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        title: Text(context.tr('my_measurements_title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: UnitToggle(
              isCm: isCm,
              onChanged: (cm) => _update(
                (d) => d.copyWith(unit: cm ? SizeUnit.cm : SizeUnit.inch),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.violet.withValues(alpha: 0.15),
                    AppColors.goldDeep.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.violet.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.gold, size: 22),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.tr('measurements_hint'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.08, end: 0),

            const SizedBox(height: AppSpacing.lg),

            Text(context.tr('preferred_size'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SizeChipSelector(
              selected: _draft.preferredSize,
              onSelect: (s) => _update((d) => d.copyWith(preferredSize: s)),
            ).animate().fadeIn(delay: 80.ms),

            const SizedBox(height: AppSpacing.lg),

            Text(context.tr('measurements_label'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            ...[
              (
                context.tr('height'),
                Icons.height_rounded,
                _draft.height,
                isCm ? context.tr('unit_cm') : context.tr('unit_in'),
                (String v) =>
                    _update((d) => d.copyWith(height: double.tryParse(v))),
              ),
              (
                context.tr('weight'),
                Icons.monitor_weight_outlined,
                _draft.weight,
                isCm ? context.tr('unit_kg') : context.tr('unit_lb'),
                (String v) =>
                    _update((d) => d.copyWith(weight: double.tryParse(v))),
              ),
              (
                context.tr('chest'),
                Icons.straighten_rounded,
                _draft.chest,
                isCm ? context.tr('unit_cm') : context.tr('unit_in'),
                (String v) =>
                    _update((d) => d.copyWith(chest: double.tryParse(v))),
              ),
              (
                context.tr('waist'),
                Icons.straighten_rounded,
                _draft.waist,
                isCm ? context.tr('unit_cm') : context.tr('unit_in'),
                (String v) =>
                    _update((d) => d.copyWith(waist: double.tryParse(v))),
              ),
              (
                context.tr('shoulder'),
                Icons.accessibility_new_rounded,
                _draft.shoulder,
                isCm ? context.tr('unit_cm') : context.tr('unit_in'),
                (String v) =>
                    _update((d) => d.copyWith(shoulder: double.tryParse(v))),
              ),
            ].asMap().entries.map((entry) {
              final i = entry.key;
              final (label, icon, value, unit, onChange) = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: MeasurementField(
                  label: label,
                  icon: icon,
                  unitLabel: unit,
                  initialValue: value?.toString(),
                  onChanged: onChange,
                ).animate().fadeIn(delay: (120 + i * 60).ms).slideX(
                      begin: 0.05,
                      end: 0,
                    ),
              );
            }),

            const SizedBox(height: AppSpacing.xl),

            PrimaryButton(
              label: _saved ? context.tr('saved_check') : context.tr('save_measurements'),
              icon: _saved ? Icons.check_rounded : Icons.save_outlined,
              onPressed: _save,
            ),

            const SizedBox(height: AppSpacing.sm),

            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(context.tr('skip_for_now')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

