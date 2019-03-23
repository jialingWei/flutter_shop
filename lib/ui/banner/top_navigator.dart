import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_shop/config/cached_network_img.dart';
import 'package:flutter_shop/ui/base_widgets.dart';

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10)
      navigatorList.removeRange(10, navigatorList.length);

    return Container(
      height: ScreenUtil().setHeight(280),
      padding: EdgeInsets.all(3.0),
//      child: GridView.count(
//        physics: NeverScrollableScrollPhysics(),
//        crossAxisCount: 5,
//        padding: EdgeInsets.all(4.0),
//        children:
//            navigatorList.map((item) => _gridViewItem(context, item)).toList(),
//      ),
      child: Table(
        children: _buildChildren(context, navigatorList),
      ),
    );
  }

  List<TableRow> _buildChildren(context, List list) {
    return [
      _buildTableRow(context, list.sublist(0, 5)),
      _buildTableRow(context, list.sublist(5, 10)),
    ];
  }

  TableRow _buildTableRow(context, List list) {
    return TableRow(
      decoration:
          BoxDecoration(color: Colors.deepOrangeAccent.withOpacity(0.05)),
      children: list.map((item) => _gridViewItem(context, item)).toList(),
    );
  }

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () => print('点击了,导航'),
      child: Column(
        children: <Widget>[
          CNImage.loadImg(
            imgUrl: item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
