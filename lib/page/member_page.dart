import 'package:flutter/material.dart';

import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/counter.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Provide<Counter>(builder: (context,child,counter){
          return Text('${counter.value}',style: Theme.of(context).textTheme.display1,);
        },),
      ),
    );
  }
}
