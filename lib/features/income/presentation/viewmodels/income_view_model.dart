import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/income/domain/entities/income.dart';
import 'package:moneyflow/features/income/presentation/providers/income_providers.dart';
import 'package:moneyflow/features/income/presentation/states/income_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'income_view_model.g.dart';

@riverpod
class IncomeViewModel extends _$IncomeViewModel {
  @override
  IncomeState build() {
    return IncomeState.initial();
  }

  /// 수입 목록 조회
  Future<void> fetchIncomeList() async {
    // TODO: implement fetchIncomeList
    throw UnimplementedError();
  }

  /// 수입 생성
  Future<void> createIncome({required Income income}) async {
    state = IncomeState.loading();

    try {
      final usecase = ref.read(createIncomeUsecaseProvider);
      final createdIncome = await usecase(income: income);

      //TODO: 생성된 수입을 목록 맨 앞에 추가

      state = state.copyWith(
        isLoading: false,
      );
    } on ValidationException catch (e) {
      state = IncomeState.error(e.message);
      rethrow;
    } on NetworkException catch (e) {
      state = IncomeState.error(e.message);
      rethrow;
    } on ServerException catch (e) {
      state = IncomeState.error(e.message);
      rethrow;
    } catch (e) {
      state = IncomeState.error(e.toString());
      rethrow;
    }
  }

  /// 수입 상세 조회

  /// 수입 수정

  /// 수입 삭제
}
