part of 'ui_task.dart';

abstract class UITaskRunner<T> {
  UITaskRunner<T> onSuccess(Function(T result) action);

  UITaskRunner<T> onFailure(Function(dynamic error) action);

  Future<T> get future;
}

class _UITaskRunnerImpl<T> implements UITaskRunner<T> {
  final BuildContextProvider buildContextProvider;
  final UITaskOption taskOption;
  @override
  final Future<T> future;
  final Logger logger = loggerFactory.getLogger("UITaskRunner");

  _UITaskRunnerImpl(this.buildContextProvider, this.taskOption, this.future) {
    updateLoading(true);
    future.then(_receiveData).catchError(_receiveError);
  }

  @override
  UITaskRunner<T> onFailure(Function(dynamic error) action) {
    future.catchError(action);
    return this;
  }

  @override
  UITaskRunner<T> onSuccess(Function(T result) action) {
    future.then(action).catchError(catchEmpty);
    return this;
  }

  void updateLoading(bool isLoading) {
    if (taskOption.loadingRef != null) {
      taskOption.loadingRef?.value = isLoading;
    } else if (taskOption.onLoadingChanged != null) {
      taskOption.onLoadingChanged?.call(isLoading);
    } else {
      if (taskOption.isShowLoading == true) {
        if (isLoading) {
          showLoading(S.current.requesting);
        } else {
          hideLoading();
        }
      }
    }
  }

  void catchEmpty(e) {}

  void _receiveData(T value) {
    if (!buildContextProvider.mounted) {
      return;
    }
    updateLoading(false);
  }

  void _receiveError(e, st) {
    if (!buildContextProvider.mounted) {
      return;
    }
    updateLoading(false);
    if (logger.isErrorEnabled) {
      logger.error(e, st);
    }
    final message = friendlyMessage(e);
    if (message != null && message.isNotEmpty) {
      showToast(message);
    }
  }

  String? friendlyMessage(e) {
    if (e is GPServerException) {
      return e.message;
    }
    if (e is DeviceMatchException) {
      return S.current.msg_error_match;
    }
    if (e is DeviceConnectException) {
      return e.errorType == ConnectErrorType.bluetoothOff
          ? S.current.tip_open_bluetooth
          : S.current.msg_error_connect;
    }
    if (e is DeviceRequestTimeoutException) {
      return S.current.msg_error_request_timeout;
    }
    if (e is DeviceUnconnectedException) {
      return S.current.msg_error_unconnected;
    }
    if (e is DomainException) {
      return e.message;
    }
    if (e is DioException) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          S.current.msg_error_request_timeout,
        _ => e.message
      };
    }
    return e.toString();
  }
}
