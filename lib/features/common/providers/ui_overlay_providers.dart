import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_overlay_providers.g.dart';

@riverpod
class AppScrimActive extends _$AppScrimActive {
  @override
  bool build() => false;

  void setActive(bool value) {
    state = value;
  }
}
