import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order/res/resources.dart';
import 'package:order/util/color_utils.dart';

import '../../../res/colors.dart';
import '../../../util/theme_utils.dart';
import '../../../util/theme_utils.dart';
import '../../../util/theme_utils.dart';

class SortPage extends StatefulWidget {
  final List<String> items;
  final double itemHeight;
  final ValueChanged<int> sortTaped;

  SortPage({Key key, this.items, this.itemHeight, this.sortTaped})
      : super(key: key);

  @override
  SortPageState createState() => SortPageState();
}

class SortPageState extends State<SortPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  int currentItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    int len = widget.items.length;
    List<Widget> widgets = List.generate(len, (i) {
      return InkWell(
        onTap: () {
          if (currentItemIndex == i) return;
          _sortTaped(i);
        },
        child: Container(
          height: widget.itemHeight,
          alignment: Alignment.center,
          child: Text(
            widget.items[i],
            style: TextStyle(
                fontSize:
                    currentItemIndex == i ? Dimens.font_sp16 : Dimens.font_sp14,
                color: currentItemIndex == i
                    ? ColorUtils.hexToColor('#2567FE')
                    : null),
          ),
        ),
      );
    });
    return Stack(
      children: <Widget>[
        Positioned(
          width: 75,
          height: widget.itemHeight,
          top: animation.value,
          child: Stack(
            children: <Widget>[
              Container(
                  color: ThemeUtils.isDark(context)
                      ? Colours.dark_material_bg
                      : Colours.bg_gray_),
              Positioned(
                top: 12.5,
                child: Container(
                  width: 3,
                  height: 20,
                  color: ColorUtils.hexToColor('#2567FE'),
                ),
              )
            ],
          ),
        ),
        Column(children: widgets)
      ],
    );
  }

  _sortTaped(int index) {
    widget.sortTaped(index);
    moveToTap(index);
  }

  moveToTap(int index) {
    double begin = currentItemIndex * widget.itemHeight;
    double end = index * widget.itemHeight;
    animation = Tween(begin: begin, end: end)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    controller.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
        currentItemIndex = index;
      }
    });

    controller.forward(from: 0);
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(microseconds: 150), vsync: this);
    animation = Tween(begin: 0.0, end: 0.0).animate(controller);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
