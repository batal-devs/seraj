import 'package:athar/app/core/models/islamic_text.dart';
import 'package:athar/app/features/daleel/domain/models/daleel_type.dart';
import 'package:athar/app/features/daleel/domain/models/hadith_authenticity.dart';
import 'package:athar/app/features/daleel/domain/models/priority.dart';

sealed class Daleel extends IslamicText {
  final String? sayer;
  final String? textWithoutDiacritics;
  final DaleelType daleelType;
  final Priority priority;
  final DateTime lastRevisedAt;

  // revision screen variables
  final int revisionCount;

  const Daleel({
    required super.id,
    required super.text,
    required this.lastRevisedAt,
    required this.revisionCount,
    required this.daleelType,
    this.sayer,
    this.textWithoutDiacritics,
    super.tags,
    super.description,
    this.priority = Priority.normal,
  });

  @override
  List<Object?> get props => [
        super.props,
        sayer,
        textWithoutDiacritics,
        priority,
        lastRevisedAt,
        revisionCount,
      ];
}

final class Aya extends Daleel {
  final String surah;
  final int firstAya;
  final int? lastAya;

  const Aya({
    required super.id,
    required super.text,
    required super.lastRevisedAt,
    required super.revisionCount,
    required super.daleelType,
    required super.textWithoutDiacritics,
    required this.surah,
    required this.firstAya,
    this.lastAya,
    super.tags,
    super.sayer,
    super.priority,
    super.description,
  });

  @override
  List<Object?> get props => [
        super.props,
        surah,
        firstAya,
        lastAya,
      ];
}

final class Hadith extends Daleel {
  final String? extraction;
  final HadithAuthenticity? authenticity;

  const Hadith({
    required super.id,
    required super.text,
    required super.lastRevisedAt,
    required super.revisionCount,
    required super.daleelType,
    required super.textWithoutDiacritics,
    super.tags,
    super.sayer,
    super.priority,
    this.extraction,
    super.description,
    this.authenticity,
  });

  @override
  List<Object?> get props => [
        super.props,
        extraction,
        authenticity,
      ];
}

final class Athar extends Daleel {
  const Athar({
    required super.id,
    required super.text,
    required super.lastRevisedAt,
    required super.revisionCount,
    required super.textWithoutDiacritics,
    required super.daleelType,
    super.tags,
    super.sayer,
    super.priority,
    super.description,
  });
}

final class Other extends Daleel {
  const Other({
    required super.id,
    required super.text,
    required super.lastRevisedAt,
    required super.revisionCount,
    required super.textWithoutDiacritics,
    required super.daleelType,
    super.tags,
    super.sayer,
    super.priority,
    super.description,
  });
}
