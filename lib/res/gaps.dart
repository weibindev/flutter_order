import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../util/theme_utils.dart';
import 'colors.dart';
import 'colors.dart';
import 'dimens.dart';

/// 间隔
class Gaps {
  /// 水平间隔
  static const Widget hGap4 = const SizedBox(width: Dimens.gap_dp4);
  static const Widget hGap5 = const SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap8 = const SizedBox(width: Dimens.gap_dp8);
  static const Widget hGap10 = const SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap12 = const SizedBox(width: Dimens.gap_dp12);
  static const Widget hGap15 = const SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = const SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap32 = const SizedBox(width: Dimens.gap_dp32);

  /// 垂直间隔
  static const Widget vGap1 = const SizedBox(height: 1.0);
  static const Widget vGap4 = const SizedBox(height: 4.0);
  static const Widget vGap5 = const SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap8 = const SizedBox(height: 8.0);
  static const Widget vGap10 = const SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap20 = const SizedBox(height: 20.0);
  static const Widget vGap12 = const SizedBox(height: 12.0);
  static const Widget vGap15 = const SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap16 = const SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap24 = const SizedBox(height: Dimens.gap_dp24);
  static const Widget vGap32 = const SizedBox(height: Dimens.gap_dp32);
  static const Widget vGap50 = const SizedBox(height: Dimens.gap_dp50);

//  static Widget line = const SizedBox(
//    height: 0.6,
//    width: double.infinity,
//    child: const DecoratedBox(decoration: BoxDecoration(color: Colours.line)),
//  );

  static Widget line = const Divider();

  static Widget vLine = const SizedBox(
    width: 0.6,
    height: 24.0,
    child: const VerticalDivider(),
  );

  static const Widget empty = const SizedBox.shrink();

  static Widget vLine10(BuildContext context) {
    return SizedBox(
      height: 10.0,
      width: double.infinity,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: ThemeUtils.isDark(context)
                  ? Colours.dark_material_bg
                  : Colours.bg_gray_)),
    );
  }

  //慎用-需要父控件占满高度
  static Widget hLine10(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 10.0,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: ThemeUtils.isDark(context)
                  ? Colours.dark_material_bg
                  : Colours.bg_gray_)),
    );
  }
}
