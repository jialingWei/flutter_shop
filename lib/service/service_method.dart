import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_shop/model/base_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'api.dart';

Future request(String url, {formData}) async {
  try {
    print('开始获取数据。。。。。url:$url');
    Response rep;


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

//获取首页热卖商品
Future getHomePageBeloContent(page) async =>
    await request(Api.homePageBelowConten, formData: page);

//获取分类商品信息
Future getCategory() async => await request(Api.getCategory);

//获取商品列表
Future<List<CategoryGoodsListData>> getMallGoods(
    String categoryId, String categorySubId, int page) async {
  var source = await request(Api.getMallGoods, formData: {
    'cagegoryId': categoryId,
    'categorySubId': categorySubId,
    'page': page
  });
  return BaseListEntity.fromJson<CategoryGoodsListData>(
      source, (mapData) => CategoryGoodsListData.fromJson(mapData)).data;
}
