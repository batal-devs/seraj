import 'package:athar/app/core/models/tag.dart';
import 'package:athar/app/features/daleel/sub_features/tags/data/daleel_tag_isar_source.dart';
import 'package:athar/app/features/dua/sub_features/dua_tag/data/dua_tag_isar_source.dart';
import 'package:injectable/injectable.dart';

@singleton
final class TagsRepository {
  final DuaTagIsarSource _duaTagIsarSource;
  final DaleelTagIsarSource _daleelTagIsarSource;

  TagsRepository(this._duaTagIsarSource, this._daleelTagIsarSource);

  List<Tag> getDaleelTags() {
    final daleelTags = _daleelTagIsarSource.getAllTags();
    return daleelTags;
  }

  List<Tag> getDuaTags() {
    final duaTags = _duaTagIsarSource.getAllTags();
    return duaTags;
  }

  void updateDaleelTags({required int id, required String newTag}) {
    _daleelTagIsarSource.updateDaleelTag(id: id, newTag: newTag);
  }

  void updateDuaTags({required int id, required String newTag}) {
    _duaTagIsarSource.updateDuaTag(id: id, newTag: newTag);
  }

  void deleteDuaTag({required int id}) {
    _duaTagIsarSource.deleteByID(id);
  }

  void deleteDaleelTag({required int id}) {
    _daleelTagIsarSource.deleteByID(id);
  }
}
