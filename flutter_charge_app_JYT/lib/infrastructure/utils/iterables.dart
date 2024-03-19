extension IterableExtension<T> on Iterable<T> {
  Map<K, T> associateBy<K>(K Function(T value) keySelector) {
    return associateByTo({}, keySelector);
  }
  M associateByTo<K, M extends Map<K, T>>(
      M destination, K Function(T value) keySelector) {
    return destination
      ..addEntries(map((item) => MapEntry(keySelector(item), item)));
  }

  /// 从最前面找到满足[predicate]返回true的值
  T? find(bool Function(T element) predicate) =>
      firstOrNull(predicate: predicate);


  /// 找到第一个满足[predicate]返回true的值,
  /// 如果[predicate]为空的话默认为true
  /// 如果找不到元素，则返回null
  T? firstOrNull({bool Function(T element)? predicate}) {
    if (predicate == null) {
      for (var element in this) {
        return element;
      }
      return null;
    }
    for (var element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }
}
