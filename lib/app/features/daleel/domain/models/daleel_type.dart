enum DaleelType { hadith, others }

// 1. hadith
// 2. ayat
// 3. athar
// 4. others

extension DaleelTypeX on DaleelType {
  bool get isHadith => this == DaleelType.hadith;
  bool get isOthers => this == DaleelType.others;
}
