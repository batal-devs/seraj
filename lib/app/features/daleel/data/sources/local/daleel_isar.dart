import 'package:athar/app/core/isar/cache_model.dart';
import 'package:athar/app/features/daleel/domain/models/daleel.dart';
import 'package:athar/app/features/daleel/domain/models/daleel_type.dart';
import 'package:athar/app/features/daleel/domain/models/hadith_authenticity.dart';
import 'package:athar/app/features/daleel/domain/models/priority.dart';
import 'package:athar/app/features/daleel/sub_features/tags/data/daleel_tag_isar.dart';
import 'package:isar/isar.dart';

part 'daleel_isar.g.dart';

@collection
final class DaleelIsar extends CacheModel<Daleel> {
  @Index(type: IndexType.value, caseSensitive: false)
  String text;
  @Index(type: IndexType.value, caseSensitive: false)
  String? textWithoutDiacritics;
  String? description;
  String? sayer;
  @Enumerated(EnumType.name)
  Priority priority;
  @Enumerated(EnumType.name)
  DaleelType daleelType;
  final tags = IsarLinks<DaleelTagIsar>();

  DateTime lastRevisedAt;

  // revision screen variables
  int revisionCount = 0;

  // Hadith-specific fields
  String? hadithExtraction;
  @Enumerated(EnumType.name)
  HadithAuthenticity? hadithAuthenticity;

  @Index(type: IndexType.value, caseSensitive: false)
  String? surah;
  int? firstAya;
  int? lastAya;

  DaleelIsar({
    required this.text,
    required this.priority,
    required this.daleelType,
    required this.lastRevisedAt,
    super.id,
    this.textWithoutDiacritics,
    this.sayer,
    this.surah,
    this.firstAya,
    this.lastAya,
    this.description,
    this.hadithExtraction,
    this.hadithAuthenticity,
  });

  factory DaleelIsar.fromDomain(Daleel daleel) => switch (daleel) {
        Hadith() => DaleelIsar(
            id: daleel.id,
            text: daleel.text,
            textWithoutDiacritics: daleel.textWithoutDiacritics,
            sayer: daleel.sayer,
            priority: daleel.priority,
            daleelType: DaleelType.hadith,
            description: daleel.description,
            lastRevisedAt: daleel.lastRevisedAt,
            hadithExtraction: daleel.extraction,
            hadithAuthenticity: daleel.authenticity,
          ),
        Aya() => DaleelIsar(
            id: daleel.id,
            text: daleel.text,
            textWithoutDiacritics: daleel.textWithoutDiacritics,
            surah: daleel.surah,
            firstAya: daleel.firstAya,
            lastAya: daleel.lastAya,
            priority: daleel.priority,
            daleelType: DaleelType.aya,
            description: daleel.description,
            lastRevisedAt: daleel.lastRevisedAt,
          ),
        Athar() => DaleelIsar(
            id: daleel.id,
            text: daleel.text,
            textWithoutDiacritics: daleel.textWithoutDiacritics,
            sayer: daleel.sayer,
            priority: daleel.priority,
            daleelType: DaleelType.athar,
            description: daleel.description,
            lastRevisedAt: daleel.lastRevisedAt,
          ),
        Other() => DaleelIsar(
            id: daleel.id,
            text: daleel.text,
            textWithoutDiacritics: daleel.textWithoutDiacritics,
            sayer: daleel.sayer,
            priority: daleel.priority,
            daleelType: DaleelType.other,
            description: daleel.description,
            lastRevisedAt: daleel.lastRevisedAt,
          ),
      };

  @override
  Daleel toDomain() {
    tags.loadSync();
    final domainTags = tags.map((tag) => tag.toDomain()).toSet();
    return switch (daleelType) {
      DaleelType.hadith => Hadith(
          id: id,
          text: text,
          textWithoutDiacritics: textWithoutDiacritics,
          sayer: sayer,
          priority: priority,
          description: description,
          extraction: hadithExtraction,
          lastRevisedAt: lastRevisedAt,
          revisionCount: revisionCount,
          authenticity: hadithAuthenticity,
          daleelType: DaleelType.hadith,
          tags: domainTags,
        ),
      DaleelType.aya => Aya(
          id: id,
          text: text,
          sayer: sayer,
          surah: surah ?? '',
          firstAya: firstAya ?? 0,
          lastAya: lastAya,
          priority: priority,
          description: description,
          textWithoutDiacritics: textWithoutDiacritics,
          lastRevisedAt: lastRevisedAt,
          revisionCount: revisionCount,
          daleelType: DaleelType.aya,
          tags: domainTags,
        ),
      DaleelType.athar => Athar(
          id: id,
          text: text,
          textWithoutDiacritics: textWithoutDiacritics,
          sayer: sayer,
          priority: priority,
          description: description,
          lastRevisedAt: lastRevisedAt,
          revisionCount: revisionCount,
          daleelType: DaleelType.athar,
          tags: domainTags,
        ),
      DaleelType.other => Other(
          id: id,
          text: text,
          textWithoutDiacritics: textWithoutDiacritics,
          sayer: sayer,
          priority: priority,
          description: description,
          lastRevisedAt: lastRevisedAt,
          revisionCount: revisionCount,
          daleelType: DaleelType.other,
          tags: domainTags,
        ),
    };
  }
}
