// MoneyFlow 앱 위젯 테스트

import 'package:flutter_test/flutter_test.dart';

import 'package:moneyflow/main.dart';

void main() {
  testWidgets('MoneyFlow app 초기화 테스트', (WidgetTester tester) async {
    // MoneyFlow 앱 실행
    await tester.pumpWidget(const MoneyFlowApp());

    // 로그인 화면이 표시되는지 확인
    expect(find.text('로그인'), findsAtLeastNWidgets(1));
  });
}
