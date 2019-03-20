import 'dart:convert';

///返回网络数据的基类
class BaseEntity<T> {
  String code;
  T data;
  String message;

  BaseEntity({this.code, this.data, this.message});

  static BaseEntity<T> fromJson<T>(
      result, Function(Map<String, dynamic> mapData) buildData) {
    Map<String, dynamic> jsonMap;

    if (result is String) {
      jsonMap = json.decode(result);
    } else {
      jsonMap = result;
    }

    return BaseEntity(
        code: jsonMap['code'] ?? -1,
        message: jsonMap['message'] ?? 'empty message',
        data: buildData(jsonMap['data']));
  }
}

///Data为List类型的基类
class BaseListEntity<T> extends BaseEntity<List<T>> {
  BaseListEntity(String code, List<T> data, String message)
      : super(code: code, data: data, message: message);

  static BaseListEntity<T> fromJson<T>(
      result, Function(Map<String, dynamic> jsonStr) buildData) {
    Map<String, dynamic> jsonMap;

    if (result is String) {
      jsonMap = json.decode(result);
    } else {
      jsonMap = result;
    }

    var code = jsonMap['code'] ?? -1;
    var message = jsonMap['message'] ?? 'empty message';
    var dataJson = jsonMap['data'];
    var data;
    if (dataJson == null) {
      data = null;
    } else {
      if (dataJson is! List) {
        throw FormatException('非List类型的json数据，请使用BaseEntity', dataJson);
      } else {
        var listDataJson = dataJson as List;
        var newList = listDataJson.map((item) => buildData(item)).toList();
        data = List<T>.from(newList);
      }
    }
    return BaseListEntity(code, data, message);
  }
}
