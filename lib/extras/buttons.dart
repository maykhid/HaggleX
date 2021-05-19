import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Button {
  static Widget plain({
    @required BuildContext context,
    @required Color buttonColor,
    @required Color buttonTextColor,
    @required String buttonText,
    double width, height,
    Function onPressed,
  }) {
    return InkWell(
      child: Container(
        width: width == null ? 70.0.w : width,
        height: height == null ? 6.5.h : height,
        child: Center(child: Text(buttonText.toUpperCase())),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
