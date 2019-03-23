import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CNImage {
//  static Widget placeholder = PlaceholderWidget();
//  static Widget errorWidget = ErrorWidget(width: ScreenUtil().setWidth(50),);

//  static void setDefaultOptions(Widget placeholder,Widget errorWidget){
//    CNImage.placeholder = placeholder;
//    CNImage.errorWidget = errorWidget;
//  }

  static Widget loadImg(
      {@required String imgUrl,
      double width,
      double height,
      BoxFit fit,
      AlignmentGeometry alignment}) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      placeholder: PlaceholderWidget(
        width: width,
        height: height,
      ),
      errorWidget: ErrorWidget(
        width: width ?? ScreenUtil().setWidth(50),
        height: height ?? ScreenUtil().setHeight(50),
      ),
    );
  }
}

///默认展位图
class PlaceholderWidget extends StatelessWidget {
  final double width;
  final double height;

  PlaceholderWidget({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
//          CircularProgressIndicator(),
          CupertinoActivityIndicator(), //ios菊花风格
          Text('努力加载中...', maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

///加载失败的占位图
class ErrorWidget extends StatelessWidget {
  final double width;
  final double height;

  ErrorWidget({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'images/loading_error.png',
              width: width,
              height: height,
            ),
            SizedBox(
              height: 10,
            ),
            Text('加载出错了...', maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
