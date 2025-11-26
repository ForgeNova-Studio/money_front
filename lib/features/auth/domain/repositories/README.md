  💡 사용 방법

  Data Layer (Repository Implementation)에서:

  try {
    final response = await dio.post('/login');
  } on DioException catch (e) {
    throw ExceptionHandler.handleDioException(e);
  }

  Presentation Layer (Riverpod)에서:

  state = await AsyncValue.guard(() async {
    return await repository.login(...);
  });

  // AsyncValue가 자동으로 Exception을 캐치하고 AsyncError로 변환

  UI에서:

  ref.watch(authProvider).when(
    data: (user) => Text('환영합니다'),
    error: (error, stack) {
      final message = ExceptionHandler.getErrorMessage(error as Exception);
      return Text(message);
    },
    loading: () => CircularProgressIndicator(),
  );