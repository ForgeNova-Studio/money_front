import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/features/common/providers/core_providers.dart';
import '../../data/datasources/memory/global_brand_source.dart';
import '../../data/datasources/local/user_brand_source.dart';
import '../../data/datasources/remote/ocr_api_service.dart';
import '../../data/strategies/fallback_brand_strategy.dart';
import '../../domain/strategies/brand_match_strategy.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../../data/repositories/ocr_repository_impl.dart';

/// OCR Feature Providers
///
/// 의존성 주입 체인:
/// DataSource → Strategy → Repository → ViewModel
///
/// 특징:
/// - 로직 클래스는 Provider (가볍고 immutable)
/// - UI 상태는 NotifierProvider (ocr_view_model.dart)
/// - GlobalBrandSource는 main.dart에서 override

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1️⃣ 데이터 소스 (Data Sources)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// GlobalBrandSource Provider
///
/// ⚠️ main.dart에서 초기화 후 overrideWithValue로 주입 필요
/// ```dart
/// final globalSource = GlobalBrandSource();
/// await globalSource.init();
/// ProviderScope(overrides: [
///   globalBrandSourceProvider.overrideWithValue(globalSource),
/// ])
/// ```
final globalBrandSourceProvider = Provider<GlobalBrandSource>((ref) {
  throw UnimplementedError('main.dart에서 override 필요');
});

/// UserBrandSource Provider
///
/// Hive 기반 사용자 학습 데이터
/// main.dart에서 초기화 후 주입
final userBrandSourceProvider = Provider<UserBrandSource>((ref) {
  throw UnimplementedError('main.dart에서 override 필요');
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2️⃣ 전략 (Strategy) - 소스 2개를 주입받음
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// BrandMatchStrategy Provider
///
/// FallbackBrandStrategy 구현:
/// - 1순위: UserBrandSource (개인 학습)
/// - 2순위: GlobalBrandSource (앱 내장)
final brandMatchStrategyProvider = Provider<BrandMatchStrategy>((ref) {
  return FallbackBrandStrategy(
    userSource: ref.watch(userBrandSourceProvider),
    globalSource: ref.watch(globalBrandSourceProvider),
  );
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3️⃣ 레포지토리 (Repository) - 전략을 주입받음
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// OcrApiService Provider
final ocrApiServiceProvider = Provider<OcrApiService>((ref) {
  return OcrApiService(dio: ref.read(dioProvider));
});

/// OcrRepository Provider
///
/// OCR 처리 파이프라인:
/// - 이미지 전처리 (ImagePreprocessor)
/// - ML Kit OCR (MlkitTextRecognizer)
/// - 패턴 파싱 (CommonPattern)
/// - 브랜드 매칭 (BrandMatchStrategy)
/// - API 전송 (OcrApiService)
final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepositoryImpl(
    brandStrategy: ref.watch(brandMatchStrategyProvider),
    apiService: ref.watch(ocrApiServiceProvider),
  );
});
