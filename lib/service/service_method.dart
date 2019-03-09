import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'api.dart';

Future request(String url, {formData}) async {
  try {
    print('开始获取数据。。。。。url:$url');
    Response rep;

    var formData = {'lon': '115.02932', 'lat': '35.76189'};

    if (formData == null)
      rep = await HttpService.instance().dio.post(url);
    else
      rep = await HttpService.instance().dio.post(url, data: formData);

    if (rep.statusCode == HttpStatus.ok) {
      return rep.data;
    } else {
      throw Exception("后端接口出现异常，请检测代码和服务器情况");
    }
  } catch (e) {
    return print('Error:======>$e');
  }
}

//获取首页主题内容
Future getHomePageContent() async {
  var formData = {'lon': '115.02932', 'lat': '35.76189'};
  return await request(Api.homePageContent, formData: formData);
}

Future getHomePageBeloContent(page) async =>
    await request(Api.homePageBelowConten, formData: page);
