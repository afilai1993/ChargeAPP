import 'package:dio/dio.dart';

import '../http_client.dart';
import '../store/user_store.dart';

class GPInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey(HttpClient.authorizationHeader)) {
      final token = userStore.getValue<String>("token");
      if (token != null && token.isNotEmpty) {
        //有token就加
        options.headers.addAll({
          // "Authorization": "Bearer ${_DioUtil.token}",
          HttpClient.authorizationHeader: token,
        });
      }
    }
    super.onRequest(options, handler);
  }
}
