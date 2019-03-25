import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_shop/service/api.dart';

class HttpService {
  static HttpService _instance;

  HttpService._internal();

  factory HttpService.instance() {
    if (_instance == null) _instance = HttpService._internal();
    return _instance;
  }

  Dio get dio => Dio(BaseOptions(
        baseUrl: Api.baseUrl,
//    connectTimeout: 10000,
//    receiveTimeout: 30000,
      ))
        ..interceptors.addAll([
          //拦截器，处理公共逻辑
          HeaderInterceptor(),
          LogInterceptor(request: true,requestBody: true,responseHeader: true,responseBody: true),
        ]);
}

class HeaderInterceptor extends Interceptor {
  static Map<String, dynamic> header;

  @override
  onRequest(RequestOptions options) {
    options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    return super.onRequest(options);
  }
}
