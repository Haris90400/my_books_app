import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.sharedPrefs}) : super(OnboardingState.initial()) {
    _loadState();
  }

  final SharedPreferences sharedPrefs;
  
  static const _keyCompleted = 'onboarding_completed';
  static const _keyLastPage = 'onboarding_last_page';

  void _loadState() {
    final isCompleted = sharedPrefs.getBool(_keyCompleted) ?? false;
    final lastPage = sharedPrefs.getInt(_keyLastPage) ?? 0;
    
    emit(state.copyWith(
      isCompleted: isCompleted,
      currentPage: lastPage,
    ));
  }

  Future<void> updatePage(int pageIndex) async {
    await sharedPrefs.setInt(_keyLastPage, pageIndex);
    emit(state.copyWith(currentPage: pageIndex));
  }

  Future<void> completeOnboarding() async {
    await sharedPrefs.setBool(_keyCompleted, true);
    emit(state.copyWith(isCompleted: true));
  }
}
