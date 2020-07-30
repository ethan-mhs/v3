import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget  {

  @override
  final Size preferredSize;

  CustomAppBar(
      { Key key,}) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: Colors.transparent,elevation: 0,iconTheme: IconThemeData(color: Colors.black),);
  }


}