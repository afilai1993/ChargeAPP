import 'package:dio/dio.dart';
import 'package:gplogger/gplogger.dart';


/// [LogInterceptor] is used to print logs during network requests.
/// It's better to add [LogInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class GPLogInterceptor extends Interceptor {
  GPLogInterceptor({
    required this.logger,
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = true,
    this.responseBody = true,
    this.error = true,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  final Logger logger;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (logger.isDebugEnabled) {
      final message = StringBuffer();
      message.write("*** Request ***\n");
      message.write(_readKV('uri', options.uri));
      message.write("\n");
      //options.headers;

      if (request) {
        message.write(_readKV('method', options.method));
        message.write("\n");
        message.write(_readKV('responseType', options.responseType.toString()));
        message.write("\n");
        message.write(_readKV('followRedirects', options.followRedirects));
        message.write("\n");
        message.write(_readKV('connectTimeout', options.connectTimeout));
        message.write("\n");
        message.write(_readKV('sendTimeout', options.sendTimeout));
        message.write("\n");
        message.write(_readKV('receiveTimeout', options.receiveTimeout));
        message.write("\n");
        message.write(_readKV(
            'receiveDataWhenStatusError', options.receiveDataWhenStatusError));
        message.write("\n");
        message.write(_readKV('extra', options.extra));
        message.write("\n");
      }
      if (requestHeader) {
        message.write('headers:\n');
        options.headers.forEach((key, v) {
          message.write(_readKV('$key', v));
          message.write("\n");
        });
      }
      if (requestBody) {
        message.write('data:\n');
        message.write(options.data.toString());
      }
      logger.debug(message);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (logger.isDebugEnabled) {
      final message = StringBuffer();
      message.write('*** Response ***\n');
      message.write(_printResponse(response));
      logger.debug(message);
    }
    handler.next(response);
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (error && logger.isDebugEnabled) {
      final message = StringBuffer();
      message.write("*** HTTP ERROR ***\n");
      message.write('uri: ${err.requestOptions.uri}\n');
      if (err.response != null) {
        message.write('*** Response ***\n');
        message.write(_printResponse(err.response!));
      } else {
        message.write("no response");
      }
      logger.warn(message, err, err.stackTrace);
    }
    handler.next(err);
  }

  String _printResponse(Response response) {
    final message = new StringBuffer();
    message.write(_readKV('uri', response.requestOptions.uri));
    message.write("\n");
    if (responseHeader) {
      message.write(_readKV('statusCode', response.statusCode));
      message.write("\n");
      if (response.isRedirect == true) {
        message.write(_readKV('redirect', response.realUri));
        message.write("\n");
      }

      message.write('headers:\n');
      response.headers.forEach((key, v) {
        message.write(_readKV('$key', v.join('\r\n\t')));
        message.write("\n");
      });
    }
    if (responseBody) {
      message.write('Response Text:\n');
      message.write(response.toString());
    }
    return message.toString();
  }

  String _readKV(String key, Object? v) => '$key:$v';
}
