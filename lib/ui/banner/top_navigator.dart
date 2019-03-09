import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children:
            navigatorList.map((item) => _gridViewItem(context, item)).toList(),
      ),
    );
  }

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () => print('点击了导航'),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:item['image'],
            width: ScreenUtil().setWidth(95),
            placeholder: PlaceholderWidget(),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }
}
