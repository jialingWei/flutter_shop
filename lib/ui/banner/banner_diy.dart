import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBanner extends StatelessWidget {
  final List swiperDataList;

  HomeBanner({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('设备像素密度：${ScreenUtil.pixelRatio}');
    print('设备高：${ScreenUtil.screenHeight}');
    print('设备宽：${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
//              swiperDataList[index]['image'].toString(),
      child: Swiper(
        itemBuilder: (context, index){
          return Card(
            elevation: 2, //阴影距离
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), //卡片圆角
            child: CachedNetworkImage(imageUrl: swiperDataList[index]['image'],fit: BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(builder: SwiperPagination.dots),
        controller: SwiperController(),
        autoplay: true,
        viewportFraction: 0.8,
        scale: 0.9,
      ),
    );
  }
}


class AdBanner extends StatelessWidget {
  final String advertesPicture;


  AdBanner({this.advertesPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(imageUrl: advertesPicture,placeholder: Icon(Icons.cloud_download),),
    );
  }
}
