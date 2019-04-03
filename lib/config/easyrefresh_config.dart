import 'package:flutter/material.dart' show Colors, GlobalKey;
import 'package:flutter_easyrefresh/easy_refresh.dart'
    show
        ClassicsFooter,
        ClassicsHeader,
        RefreshFooterState,
        RefreshHeaderState;

ClassicsHeader getDefaultHeader(GlobalKey<RefreshHeaderState> headerKey) {
  return ClassicsHeader(
    key: headerKey,
    refreshText: "下拉刷新",
    refreshReadyText: "释放刷新",
    refreshingText: "正在刷新...",
    refreshedText: "刷新结束",
    moreInfo: "更新于 %T",
    bgColor: Colors.transparent,
    textColor: Colors.pink,
    moreInfoColor: Colors.pink,
    showMore: true,
  );
}

ClassicsFooter getDefaultFooter(GlobalKey<RefreshFooterState> footerKey,String noMoreStr){
  return ClassicsFooter(
    key: footerKey,
    loadText: "上拉加载",
    loadReadyText: "释放加载",
    loadingText: "正在加载",
    loadedText: "加载结束",
    noMoreText: noMoreStr,
    moreInfo: "更新于 %T",
    bgColor: Colors.transparent,
    textColor: Colors.pink,
    moreInfoColor: Colors.pink,
    showMore: true,
  );
}
