import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moneyflow/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moneyflow/features/ocr/data/datasources/memory/global_brand_source.dart';

class AppInitialization {
  final SharedPreferences sharedPreferences;
  final GlobalBrandSource globalBrandSource;
  final UserBrandSource userBrandSource;

  AppInitialization({
    required this.sharedPreferences,
    required this.globalBrandSource,
    required this.userBrandSource,
  });
}

/// 앱 시작 시 필요한 비동기 초기화
final appInitializationProvider = FutureProvider<AppInitialization>((ref) async {
  await initializeDateFormatting('ko_KR', null);

  final sharedPreferences = await SharedPreferences.getInstance();

  await Hive.initFlutter();

  final globalBrandSource = GlobalBrandSource();
  await globalBrandSource.initialize();

  final userBrandSource = UserBrandSource();
  await userBrandSource.init();

  return AppInitialization(
    sharedPreferences: sharedPreferences,
    globalBrandSource: globalBrandSource,
    userBrandSource: userBrandSource,
  );
});
