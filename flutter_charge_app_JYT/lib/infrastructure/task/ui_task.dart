import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/exception.dart';
import 'package:dio/dio.dart';

import '../../domain/device/exception.dart';
import '../infrastructure.dart';

part 'ui_task_runner.dart';

part 'build_context_provider.dart';

class UITaskOption {
  final bool? isShowLoading;
  final Function(bool loading)? onLoadingChanged;
  final BoolStateRef? loadingRef;

  const UITaskOption({
    this.onLoadingChanged,
    this.loadingRef,
    this.isShowLoading,
  });
}

class UITask {
  final BuildContextProvider buildContextProvider;
  UITaskOption _options = const UITaskOption();

  UITask._(this.buildContextProvider);

  UITask options(UITaskOption options) {
    _options = options;
    return this;
  }

  UITaskRunner<T> run<T>(Future<T> future) =>
      _UITaskRunnerImpl(buildContextProvider, _options, future);
}

extension BuildContextTaskRunner on BuildContext? {
  UITask get uiTask {
    return UITask._(createBuildContextProvider());
  }
}

extension StateTaskRunner on State {
  UITask get uiTask {
    return UITask._(createBuildContextProvider());
  }
}
