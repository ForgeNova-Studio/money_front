/// 모델 리스트를 엔티티 리스트로 변환한다.
List<TEntity> mapModelsToEntities<TModel, TEntity>(
  Iterable<TModel> models,
  TEntity Function(TModel model) toEntity,
) {
  return models.map(toEntity).toList();
}

/// 단건 모델 요청 결과를 엔티티로 변환한다.
Future<TEntity> mapModelToEntity<TModel, TEntity>({
  required Future<TModel> request,
  required TEntity Function(TModel model) toEntity,
}) async {
  final model = await request;
  return toEntity(model);
}

/// 엔티티 -> 모델 변환 후 요청하고, 응답 모델을 다시 엔티티로 변환한다.
Future<TEntity> mapEntityRoundTrip<TEntity, TModel>({
  required TEntity entity,
  required TModel Function(TEntity entity) toModel,
  required Future<TModel> Function(TModel model) request,
  required TEntity Function(TModel model) toEntity,
}) async {
  final model = toModel(entity);
  final responseModel = await request(model);
  return toEntity(responseModel);
}
