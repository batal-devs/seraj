part of 'add_dua_cubit.dart';

final class AddDuaState extends Equatable with FormzMixin {
  const AddDuaState({
    this.dua = const Name.pure(),
    this.reward = const Name.pure(),
    this.priority = Priority.normal,
    this.description = '',
    this.errorMessage,
    this.duaId,
    this.tags = const {},
  });

  final Name dua;
  final Name reward;
  final Priority priority;
  final String description;
  final String? errorMessage;
  final int? duaId;
  final Set<Tag> tags;

  @override
  List<Object?> get props => [
        duaId,
        dua,
        tags,
        reward,
        description,
        priority,
        errorMessage,
      ];

  AddDuaState copyWith({
    Name? dua,
    int? duaId,
    Name? reward,
    Priority? priority,
    String? description,
    Set<Tag>? tags,
    double? sliderValue,
    String? errorMessage,
  }) {
    return AddDuaState(
      priority: priority ?? this.priority,
      description: description ?? this.description,
      dua: dua ?? this.dua,
      duaId: duaId ?? this.duaId,
      tags: tags ?? this.tags,
      reward: reward ?? this.reward,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  // ignore: strict_raw_type
  List<FormzInput> get inputs => [dua];
}
