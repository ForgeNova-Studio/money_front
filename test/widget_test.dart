// MoneyFlow 앱 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moamoa/features/common/providers/app_init_provider.dart';
import 'package:moamoa/features/ocr/data/datasources/local/user_brand_source.dart';
import 'package:moamoa/features/ocr/data/datasources/memory/global_brand_source.dart';
import 'package:moamoa/main.dart';

void main() {
  testWidgets('MoneyFlow app 루트 위젯이 정상 빌드된다', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'has_seen_onboarding': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appInitializationProvider.overrideWith(
            (ref) async => AppInitialization(
              sharedPreferences: prefs,
              globalBrandSource: GlobalBrandSource(),
              userBrandSource: UserBrandSource(),
            ),
          ),
        ],
        child: const MoneyFlowApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
