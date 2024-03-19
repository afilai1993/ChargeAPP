extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> removeNullValue() {
    final result = <K, V>{};
    for (var entity in entries) {
      if (entity.value != null) {
        result[entity.key] = entity.value;
      }
    }
    return result;
  }
}
