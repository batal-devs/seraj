import 'dart:developer';

import 'package:athar/app/core/enums/status.dart';
import 'package:athar/app/core/extension_methods/double_x.dart';
import 'package:athar/app/core/extension_methods/string_x.dart';
import 'package:athar/app/core/models/generic_exception.dart';
import 'package:athar/app/core/models/tag.dart';
import 'package:athar/app/features/daleel/domain/models/daleel.dart';
import 'package:athar/app/features/daleel/domain/repositories/daleel_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'add_edit_aya_state.dart';

class AddEditAyahCubit extends Cubit<AddEditAyahState> {
  final DaleelRepository _daleelRepository;
  late TextEditingController surahController;
  late TextEditingController quranicVerseController;
  late TextEditingController firstAyahController;
  late TextEditingController lastAyahController;
  late TextEditingController explanationController;

  AddEditAyahCubit({
    required DaleelRepository ayaRepository,
  })  : _daleelRepository = ayaRepository,
        super(const AddEditAyahState()) {
    surahController = TextEditingController();
    quranicVerseController = TextEditingController();
    firstAyahController = TextEditingController();
    lastAyahController = TextEditingController();
    explanationController = TextEditingController();

    _initializeListeners();
  }

  void _initializeListeners() {
    surahController.addListener(() {
      surahOfAyaChanged(surahController.text);
    });
    firstAyahController.addListener(() {
      final value = int.tryParse(firstAyahController.text);
      if (value != null) {
        nomOfAyaChanged(value);
      }
    });
    explanationController.addListener(() {
      ayaExplainChanged(explanationController.text);
    });
    quranicVerseController.addListener(() {
      textOfAyaChanged(quranicVerseController.text);
    });
  }

  void textOfAyaChanged(String value) => emit(state.copyWith(textOfAya: Name.dirty(value)));

  void surahOfAyaChanged(String value) => emit(state.copyWith(surahOfAya: Name.dirty(value)));

  void nomOfAyaChanged(int value) => emit(state.copyWith(firstAya: value));

  void ayaExplainChanged(String value) => emit(state.copyWith(ayaExplain: value));

  void queryChanged(String value) {
    final ayahsList = FlutterQuran().search(value);
    if (ayahsList.isNotEmpty || value.isBlank) {
      emit(state.copyWith(query: value, ayahs: ayahsList));
    }
  }

  void _updateControllers() {
    if (state.selectedAyahs.isNotEmpty) {
      surahController.text = state.surahOfAya.value;
      firstAyahController.text = state.firstAya.toString();
      lastAyahController.text = state.lastAya.toString();
      explanationController.text = state.ayaExplain ?? '';
      quranicVerseController.text =
          state.selectedAyahs.map((singleAyah) => singleAyah.ayah).join(' ').replaceAll('\n', ' ');
    }
  }

  Future<void> ayahsChanged(List<Ayah> ayahs) async {
    if (ayahs.isNotEmpty) {
      final id = await _daleelRepository.isAyahExist(
        surahName: ayahs[0].surahNameAr,
        ayahNumber: ayahs[0].ayahNumber,
      );
      if (id != null) {
        emit(state.copyWith(
          status: const Failure(
            BusinessException(message: 'Aya already exists', code: '0'),
          ),
          ayahs: [],
          ayaId: id,
        ));
      } else {
        emit(state.copyWith(
          selectedAyahs: ayahs,
          query: '',
          ayahs: [],
          surahOfAya: Name.dirty(ayahs[0].surahNameAr),
          firstAya: ayahs.first.ayahNumber,
          lastAya: ayahs.last.ayahNumber,
          ayaExplain: '',
        ));
      }
    } else {
      emit(state.copyWith(selectedAyahs: [], query: '', ayahs: []));
    }
    _updateControllers();
  }

  void initializeAya(int? ayaId) {
    if (ayaId == null) {
    } else {
      emit(state.copyWith(status: const Loading()));

      log(ayaId.toString());

      final daleel = _daleelRepository.get(ayaId);

      quranicVerseController.text = daleel!.text;
      surahController.text = (daleel as Aya).surah;
      firstAyahController.text = daleel.firstAya.toString();
      lastAyahController.text = daleel.lastAya.toString();
      explanationController.text = daleel.description ?? '';

      emit(state.copyWith(
        ayaId: ayaId,
        textOfAya: Name.dirty(daleel.text),
        ayaExplain: daleel.description ?? '',
        surahOfAya: Name.dirty(daleel.surah),
        lastAya: daleel.lastAya,
        firstAya: daleel.firstAya,
        tags: daleel.tags,
      ));

      emit(state.copyWith(status: const Success(null)));
    }
  }

  void tagsChanged(Set<Tag> newTags) {
    emit(state.copyWith(tags: newTags));
  }

  Future<void> saveAyaForm() async {
    emit(state.copyWith(status: const Loading()));
    try {
      await _daleelRepository.saveOrUpdateAya(
        id: state.ayaId,
        text: state.textOfAya.value,
        textWithoutDiacritics: state.textOfAya.value.removeDiacritics(),
        ayaExplain: state.ayaExplain ?? '',
        surahOfAya: state.surahOfAya.value,
        firstAya: state.firstAya,
        lastAya: state.lastAya,
        priority: 1.0.getPriority(),
        tags: state.tags,
      );
      emit(state.copyWith(status: const Success(null)));
    } catch (e) {
      emit(state.copyWith(status: Failure(e as GenericException)));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: const Initial()));
  }

  List<Tag> getTags() {
    return _daleelRepository.getTags();
  }

  @override
  Future<void> close() {
    // Dispose controllers
    surahController.dispose();
    firstAyahController.dispose();
    lastAyahController.dispose();
    explanationController.dispose();
    return super.close();
  }
}
