import 'package:equatable/equatable.dart';

enum SizeUnit { cm, inch }

class Measurements extends Equatable {
  final double? height;
  final double? weight;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? shoulder;
  final String? preferredSize;
  final SizeUnit unit;
  final DateTime updatedAt;

  const Measurements({
    this.height,
    this.weight,
    this.chest,
    this.waist,
    this.hips,
    this.shoulder,
    this.preferredSize,
    this.unit = SizeUnit.cm,
    required this.updatedAt,
  });

  factory Measurements.fromMap(Map<String, dynamic> map) {
    return Measurements(
      height: (map['height'] as num?)?.toDouble(),
      weight: (map['weight'] as num?)?.toDouble(),
      chest: (map['chest'] as num?)?.toDouble(),
      waist: (map['waist'] as num?)?.toDouble(),
      hips: (map['hips'] as num?)?.toDouble(),
      shoulder: (map['shoulder'] as num?)?.toDouble(),
      preferredSize: map['preferredSize'] as String?,
      unit: map['unit'] == 'inch' ? SizeUnit.inch : SizeUnit.cm,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAtMillis'] as int? ??
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'shoulder': shoulder,
      'preferredSize': preferredSize,
      'unit': unit == SizeUnit.inch ? 'inch' : 'cm',
      'updatedAtMillis': updatedAt.millisecondsSinceEpoch,
    };
  }

  Measurements copyWith({
    double? height,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? shoulder,
    String? preferredSize,
    SizeUnit? unit,
  }) {
    return Measurements(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      shoulder: shoulder ?? this.shoulder,
      preferredSize: preferredSize ?? this.preferredSize,
      unit: unit ?? this.unit,
      updatedAt: DateTime.now(),
    );
  }

  bool get isEmpty =>
      height == null &&
      weight == null &&
      chest == null &&
      waist == null &&
      hips == null &&
      shoulder == null;

  @override
  List<Object?> get props =>
      [height, weight, chest, waist, hips, shoulder, preferredSize, unit];
}