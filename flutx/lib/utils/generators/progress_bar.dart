/// [FxProgressBar] - builds a widget for showing linear progress for anything.

import 'package:flutter/material.dart';

class FxProgressBar {
  static Widget buildProgress(
      {Color? activeColor,
      Color? inactiveColor,
      double progress = 1,
      double height = 4,
      double width = 100}) {
    if (inactiveColor == null) {
      inactiveColor = Colors.grey;
    }

    if (progress > 1) {
      progress /= 100;
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: inactiveColor,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Stack(
        children: <Widget>[
          Container(
            width: width * progress,
            height: height,
            decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          )
        ],
      ),
    );
  }
}
