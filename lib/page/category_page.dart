import 'package:flutter/material.dart';

import 'package:flutter_shop/service/service_method.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  @override
  Widget build(BuildContext context) {
    getCategory();
    return Container(
      child: Center(
        child: Text("搜索分类"),
      ),
    );
  }
}
