extension StringExtension on String {
  // "" 转null
  String? emptyToNull() => isEmpty ? null : this;

  bool get isBlank => trim().isEmpty;

  /// 不是空字符组成的字符串
  bool get isNotBlank => !isBlank;

  String repeat(int count, [String separator = ""]) {
    final StringBuffer sb = StringBuffer();
    if (separator.isEmpty) {
      for (int index = 0; index < count; index++) {
        sb.write(this);
      }
    } else {
      for (int index = 0; index < count; index++) {
        sb.write(this);
        if (index != count - 1) {
          sb.write(separator);
        }
      }
    }
    return sb.toString();
  }
}
