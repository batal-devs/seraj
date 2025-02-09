// ignore_for_file: unused_field

import 'dart:developer';

import 'package:athar/app/core/models/generic_exception.dart';
import 'package:athar/app/core/models/repository.dart';
import 'package:athar/app/core/models/tag.dart';
import 'package:athar/app/features/daleel/data/sources/local/daleel_isar.dart';
import 'package:athar/app/features/daleel/data/sources/local/daleel_isar_source.dart';
import 'package:athar/app/features/daleel/domain/models/daleel.dart';
import 'package:athar/app/features/daleel/domain/models/daleel_type.dart';
import 'package:athar/app/features/daleel/domain/models/hadith_authenticity.dart';
import 'package:athar/app/features/daleel/domain/models/priority.dart';
import 'package:athar/app/features/daleel/presentation/models/daleel_filters.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
final class DaleelRepository extends Repository<Daleel, DaleelIsar> {
  final DaleelIsarSource _localSource;

  DaleelRepository(this._localSource) : super(_localSource);

  /// Saves or updates a Daleel entry in the database
  Future<Either<Exception, void>> _saveOrUpdateDaleel({
    required DaleelIsar daleelIsar,
    required Set<Tag> tags,
  }) async {
    try {
      if (daleelIsar.id == null) {
        _localSource.addDaleelWithTags(daleelIsar: daleelIsar, tags: tags);
      } else {
        _localSource.updateDaleelWithTags(daleelIsar: daleelIsar, tags: tags);
      }
      return right(null);
    } catch (e, stackTrace) {
      log('Error saving Daleel: $e', stackTrace: stackTrace);
      return left(e as GenericException);
    }
  }

  Future<Either<Exception, void>> saveOrUpdateHadith({
    required String text,
    required String sayer,
    required Priority priority,
    required String extraction,
    required Set<Tag> tags,
    required String description,
    required HadithAuthenticity? authenticity,
    int? id,
  }) async {
    return _saveOrUpdateDaleel(
      daleelIsar: DaleelIsar(
        id: id,
        text: text,
        sayer: sayer.isEmpty ? null : sayer,
        priority: priority,
        daleelType: DaleelType.hadith,
        description: description.isEmpty ? null : description,
        lastRevisedAt: DateTime.now(),
        hadithExtraction: extraction.isEmpty ? null : extraction,
        hadithAuthenticity: authenticity,
      ),
      tags: tags,
    );
  }

  Future<Either<Exception, void>> saveOrUpdateAthar({
    required String text,
    required String sayer,
    required Priority priority,
    required Set<Tag> tags,
    required String description,
    int? id,
  }) async {
    return _saveOrUpdateDaleel(
      daleelIsar: DaleelIsar(
        id: id,
        text: text,
        sayer: sayer.isEmpty ? null : sayer,
        priority: priority,
        daleelType: DaleelType.athar,
        description: description.isEmpty ? null : description,
        lastRevisedAt: DateTime.now(),
      ),
      tags: tags,
    );
  }

  Future<Either<Exception, void>> saveOrUpdateAya({
    required String text,
    required String ayaExplain,
    required String surahOfAya,
    required int firstAya,
    required int lastAya,
    required Priority priority,
    required DateTime lastRevisedAt,
    required Set<Tag> tags,
    String? sayer,
    int? id,
  }) async {
    return _saveOrUpdateDaleel(
      daleelIsar: DaleelIsar(
        id: id,
        text: text,
        sayer: sayer,
        priority: priority,
        daleelType: DaleelType.aya,
        description: ayaExplain,
        lastRevisedAt: lastRevisedAt,
        surah: surahOfAya,
        firstAya: firstAya,
        lastAya: lastAya,
      ),
      tags: tags,
    );
  }

  Future<Either<Exception, void>> saveOrUpdateOthers({
    required String text,
    required String sayer,
    required String description,
    required Priority priority,
    required DateTime lastRevisedAt,
    required Set<Tag> tags,
    int? id,
  }) async {
    return _saveOrUpdateDaleel(
      daleelIsar: DaleelIsar(
        id: id,
        text: text,
        sayer: sayer.isEmpty ? null : sayer,
        priority: priority,
        daleelType: DaleelType.other,
        description: description.isEmpty ? null : description,
        lastRevisedAt: lastRevisedAt,
      ),
      tags: tags,
    );
  }

  /// Checks if a specific Ayah exists in the local database
  Future<int?> isAyahExist({required String surahName, required int ayahNumber}) async {
    final aya = await _localSource.getAyaByText(surahName: surahName, ayahNumber: ayahNumber);
    return aya?.id;
  }

  /// Searches for Daleel entries based on filters and pagination
  Future<List<Daleel>> searchDaleel(
    String searchTerm, {
    required int page,
    required int pageSize,
    DaleelFilters? filters,
  }) async {
    final results = await _localSource.getDaleels(
      searchTerm,
      page: page,
      filters: filters,
      pageSize: pageSize,
    );

    return results.map((e) => e.toDomain()).toList();
  }

  Future<void> deleteDoc(int id) async => _localSource.deleteDoc(id);

  @override
  DaleelIsar fromDomain(Daleel dm) => DaleelIsar.fromDomain(dm);
}
