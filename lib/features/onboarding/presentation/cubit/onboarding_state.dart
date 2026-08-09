import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.currentPage,
    required this.isCompleted,
  });

  final int currentPage;
  final bool isCompleted;

  factory OnboardingState.initial() => const OnboardingState(
        currentPage: 0,
        isCompleted: false,
      );

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [currentPage, isCompleted];
}
