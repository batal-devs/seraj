// ignore_for_file: unused_field

import 'dart:developer';

import 'package:athar/app/features/daleel/domain/models/daleel.dart';
import 'package:athar/app/features/daleel/domain/repositories/daleel_repository.dart';
import 'package:athar/app/features/daleel/presentation/models/daleel_filters.dart';
import 'package:athar/app/features/daleel/sub_features/daleel_revision/cubit/daleel_revision_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class DaleelRevisionCubit extends Cubit<DaleelRevisionState> {
  int currentIndex = 0;
  late CardSwiperController cardSwiperController;

  final DaleelRepository _repository;
  final DaleelFilters daleelFilters;
  DaleelRevisionCubit(this._repository, this.daleelFilters)
      : super(const DaleelRevisionState()) {
    initalizeDaleelRevision();
    cardSwiperController = CardSwiperController();
  }

  List<Daleel> getDaleels() =>
      _repository.getSortedDaleels(daleelTypes: daleelFilters.daleelType);

  void initalizeDaleelRevision() async {
    log('initialize daleels');
    emit(state.copyWith(status: DaleelRevisionStatus.loading));
    try {
      final daleels = getDaleels();
      emit(state.copyWith(
          daleel: daleels,
          status: DaleelRevisionStatus.success,
          currentIndex: 0,
          showReviewButton: false));
    } catch (e) {
      log('Error initializing Daleels: $e');
      emit(state.copyWith(status: DaleelRevisionStatus.failure));
    }
  }

  void incrementRevisionCount(int id) {
    log('id of the daleel by incremented by 1 is $id');
    _repository.incrementRevisionCount(id);
  }

  void updateCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void setShowReviewButton(bool value) {
    emit(state.copyWith(showReviewButton: value));
  }

  @override
  Future<void> close() {
    cardSwiperController.dispose();
    return super.close();
  }
}
