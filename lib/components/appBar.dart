import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar HomeAppBar(String text) {
  return AppBar(
    title: Text(text),
    backgroundColor: Colors.pink[400],
    elevation: 0.0,
    leading: Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SvgPicture.asset(
        "assets/svg/littleMemoriesIcon.svg",
      ),
    ),
  );
}
