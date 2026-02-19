import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/notification/presentation/models/notification_filter_type.dart';
import 'package:moamoa/features/notification/presentation/widgets/notification_list/notification_filter_tabs.dart';

void main() {
  group('NotificationFilterTabs', () {
    testWidgets('필터 라벨을 렌더링한다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationFilterTabs(
              selectedType: NotificationFilterType.all,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('전체'), findsOneWidget);
      expect(find.text('공지'), findsOneWidget);
      expect(find.text('개인'), findsOneWidget);
      expect(find.text('업데이트'), findsOneWidget);
      expect(find.text('이벤트'), findsOneWidget);
    });

    testWidgets('탭 선택 시 onChanged 콜백을 호출한다', (tester) async {
      NotificationFilterType? changedType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationFilterTabs(
              selectedType: NotificationFilterType.all,
              onChanged: (type) => changedType = type,
            ),
          ),
        ),
      );

      await tester.tap(find.text('공지'));
      await tester.pumpAndSettle();

      expect(changedType, NotificationFilterType.notice);
    });
  });
}
