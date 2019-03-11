import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


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
          CircularProgressIndicator(),
          Text('努力加载中...', maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}


