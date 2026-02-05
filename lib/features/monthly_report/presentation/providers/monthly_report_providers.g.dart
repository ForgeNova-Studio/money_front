// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Remote DataSource Provider

@ProviderFor(monthlyReportRemoteDataSource)
const monthlyReportRemoteDataSourceProvider =
    MonthlyReportRemoteDataSourceProvider._();

/// Remote DataSource Provider

final class MonthlyReportRemoteDataSourceProvider extends $FunctionalProvider<
        MonthlyReportRemoteDataSource,
        MonthlyReportRemoteDataSource,
        MonthlyReportRemoteDataSource>
    with $Provider<MonthlyReportRemoteDataSource> {
  /// Remote DataSource Provider
  const MonthlyReportRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'monthlyReportRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<MonthlyReportRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MonthlyReportRemoteDataSource create(Ref ref) {
    return monthlyReportRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonthlyReportRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<MonthlyReportRemoteDataSource>(value),
    );
  }
}

String _$monthlyReportRemoteDataSourceHash() =>
    r'7f670e730826acc9166a56abbe6450987dc53ffe';

/// Repository Provider

@ProviderFor(monthlyReportRepository)
const monthlyReportRepositoryProvider = MonthlyReportRepositoryProvider._();

/// Repository Provider

final class MonthlyReportRepositoryProvider extends $FunctionalProvider<
    MonthlyReportRepository,
    MonthlyReportRepository,
    MonthlyReportRepository> with $Provider<MonthlyReportRepository> {
  /// Repository Provider
  const MonthlyReportRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'monthlyReportRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<MonthlyReportRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MonthlyReportRepository create(Ref ref) {
    return monthlyReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonthlyReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonthlyReportRepository>(value),
    );
  }
}

String _$monthlyReportRepositoryHash() =>
    r'c653b1b3fda13db20cb6c9339ea0a808c1f7bda9';

/// 월간 리포트 조회 Provider

@ProviderFor(monthlyReport)
const monthlyReportProvider = MonthlyReportFamily._();

/// 월간 리포트 조회 Provider

final class MonthlyReportProvider extends $FunctionalProvider<
        AsyncValue<MonthlyReportEntity>,
        MonthlyReportEntity,
        FutureOr<MonthlyReportEntity>>
    with
        $FutureModifier<MonthlyReportEntity>,
        $FutureProvider<MonthlyReportEntity> {
  /// 월간 리포트 조회 Provider
  const MonthlyReportProvider._(
      {required MonthlyReportFamily super.from,
      required ({
        String accountBookId,
        int year,
        int month,
      })
          super.argument})
      : super(
          retry: null,
          name: r'monthlyReportProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportHash();

  @override
  String toString() {
    return r'monthlyReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlyReportEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyReportEntity> create(Ref ref) {
    final argument = this.argument as ({
      String accountBookId,
      int year,
      int month,
    });
    return monthlyReport(
      ref,
      accountBookId: argument.accountBookId,
      year: argument.year,
      month: argument.month,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyReportHash() => r'a0d1fcca6aed345e9449880542a0aebf083b8968';

/// 월간 리포트 조회 Provider

final class MonthlyReportFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<MonthlyReportEntity>,
            ({
              String accountBookId,
              int year,
              int month,
            })> {
  const MonthlyReportFamily._()
      : super(
          retry: null,
          name: r'monthlyReportProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// 월간 리포트 조회 Provider

  MonthlyReportProvider call({
    required String accountBookId,
    required int year,
    required int month,
  }) =>
      MonthlyReportProvider._(argument: (
        accountBookId: accountBookId,
        year: year,
        month: month,
      ), from: this);

  @override
  String toString() => r'monthlyReportProvider';
}
