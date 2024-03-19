import 'dart:core';

import 'package:chargestation/design.dart';
import 'package:flutter/foundation.dart';

export 'glogger.dart';
export '../../generated/l10n.dart';
export '../repository/http_client.dart';
export '../repository/store/user_store.dart';
export 'task/ui_task.dart';
export 'state_provider.dart';
export '../repository/repository.dart';
export 'permission.dart';
export 'package:intl/intl.dart';
export 'utils/utils.dart';

extension NavigatorContextExtension on BuildContext {
  Future<T?> redirectTo<T extends Object?, TO extends Object?>(
    String name, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this)
        .pushReplacementNamed(name, result: result, arguments: arguments);
  }

  Future<T?> navigateTo<T extends Object?>(String name, {Object? arguments}) {
    return Navigator.of(this).pushNamed(name, arguments: arguments);
  }

  void navigateBack<T extends Object?>([T? result]) {
    return Navigator.of(this).pop(result);
  }
}

extension UrlExtension on String {
  String fullUrl() {
    if (isEmpty) {
      return "";
    }
    //return "${InfrastructureConfig.httpHost}${this}";
    return "http://192.168.11.31:8799${this}";
  }
}
