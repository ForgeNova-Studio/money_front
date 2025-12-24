import 'package:intl/intl.dart';
import 'package:moneyflow/features/home/domain/usecases/get_home_monthly_data_usecase.dart';
import 'package:moneyflow/features/home/presentation/providers/home_providers.dart';
import 'package:moneyflow/features/home/presentation/states/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final now = DateTime.now();
    // 초기 상태 설정 후 데이터 로드
    Future.microtask(() => fetchMonthlyData(now));
    
    return HomeState(
      focusedMonth: now,
      selectedDate: now,
    );
  }

  /// 특정 월의 데이터를 가져옵니다.
  Future<void> fetchMonthlyData(DateTime month) async {
    state = state.copyWith(
      monthlyData: const AsyncValue.loading(),
      focusedMonth: month,
    );

    final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
    
    final result = await AsyncValue.guard(
      () => useCase(yearMonth: month),
    );

    state = state.copyWith(monthlyData: result);
  }

  /// 날짜가 선택되었을 때 호출
  void selectDate(DateTime selectedDate) {
    state = state.copyWith(selectedDate: selectedDate);
  }

  /// 달력의 달이 바뀌었을 때 호출
  void changeMonth(DateTime focusedMonth) {
    if (focusedMonth.year != state.focusedMonth.year || 
        focusedMonth.month != state.focusedMonth.month) {
      fetchMonthlyData(focusedMonth);
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    await fetchMonthlyData(state.focusedMonth);
  }
}
