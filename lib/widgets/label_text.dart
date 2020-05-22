import 'package:flutter/material.dart';
import 'package:order/res/resources.dart';

class LabelText extends StatelessWidget {
  final EdgeInsets padding;
  final GestureTapCallback onPressed;
  final String text;
  final Color backgroundColor;
  final double radius;
  final Color textColor;
  final double textSize;
  final BoxShape shape;

  LabelText({
    Key key,
    @required this.padding,
    @required this.text,
    @required this.backgroundColor,
    this.radius = 4.0,
    this.textColor = Colors.white,
    this.textSize = Dimens.font_sp12,
    this.shape = BoxShape.rectangle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: shape,
            color: backgroundColor,
            borderRadius: shape == BoxShape.circle
                ? null
                : BorderRadius.circular(radius)),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: textSize),
          ),
        ),
      ),
    );
  }
}
