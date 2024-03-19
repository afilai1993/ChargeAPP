import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'http/gp_interceptor.dart';
import 'http/log_interceptor.dart';

abstract class HttpClient {
  static const authorizationHeader = "Authorization";

  Future<dynamic> get(url,
      {Map<String, Object?>? queries, Map<String, dynamic>? headers});

  Future<dynamic> post(
    url, {
    Map<String, Object?>? queries,
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> put(
    url, {
    Map<String, Object?>? queries,
    Object? data,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> delete(url,
      {Map<String, Object?>? queries, Map<String, dynamic>? headers});
}

HttpClient? _cache;

HttpClient get httpClient {
  final current = _cache;
  if (current != null) {
    return current;
  }
  final created = _HttpClientImpl(_createDio());
  _cache = created;
  return created;
}

Dio _createDio() {
  const timeout = 20 * 1000;
  final created = Dio(BaseOptions(
    baseUrl: RepositoryConfig.httpHost,
    connectTimeout: const Duration(milliseconds: timeout),
    sendTimeout: const Duration(milliseconds: timeout),
    receiveTimeout: const Duration(milliseconds: timeout),
  ));
  if (!kReleaseMode) {
    created.interceptors
        .add(GPLogInterceptor(logger: loggerFactory.getLogger("HTTP")));
  }
  created.interceptors.add(GPInterceptor());
  return created;
}

class GPServerException implements Exception {
  final int code;
  final String message;

  GPServerException(this.code, this.message);

  @override
  String toString() {
    return 'code: $code, $message}';
  }
}

class _HttpClientImpl implements HttpClient {
  final Dio dio;

  _HttpClientImpl(this.dio);

  @override
  Future delete(url,
          {Map<String, Object?>? queries, Map<String, dynamic>? headers}) =>
      request(url,
          queries: queries,
          options: Options(method: "DELETE", headers: headers));

  @override
  Future get(url,
          {Map<String, Object?>? queries, Map<String, dynamic>? headers}) =>
      request(url,
          queries: queries, options: Options(method: "GET", headers: headers));

  @override
  Future post(url,
          {Map<String, Object?>? queries,
          Object? data,
          Map<String, dynamic>? headers}) =>
      request(url,
          queries: queries,
          data: data,
          options: Options(method: "POST", headers: headers));

  @override
  Future put(url,
          {Map<String, Object?>? queries,
          Object? data,
          Map<String, dynamic>? headers}) =>
      request(url,
          queries: queries,
          data: data,
          options: Options(method: "PUT", headers: headers));

  Future request(
    url, {
    Map<String, Object?>? queries,
    Object? data,
    required Options options,
  }) =>
      dio
          .request(url, data: data, queryParameters: queries, options: options)
          .then((value) {
        if (value.statusCode != 200) {
          return value;
        }
        final data = value.data;
        if (data["code"] != 200) {
          return Future.error(
              GPServerException(data["code"], data["msg"] ?? ""));
        }
        return data;
      });
}
