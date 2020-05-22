import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/res/resources.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/util/theme_utils.dart';

///自定义AppBar
class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  const Toolbar(
      {Key key,
      this.backgroundColor,
      this.titleColor,
      this.title: '',
      this.centerTitle: '',
      this.actionName: '',
      this.backImg: 'assets/images/ic_back_black.png',
      this.onPressed,
      this.onBack,
      this.isBack: true})
      : super(key: key);

  final Color backgroundColor;
  final Color titleColor;
  final String title;
  final String centerTitle;
  final String backImg;
  final String actionName;
  final VoidCallback onPressed;
  final VoidCallback onBack;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor;
    Color _titleColor;

    if (backgroundColor == null) {
      _backgroundColor = ThemeUtils.getBackgroundColor(context);
    } else {
      _backgroundColor = backgroundColor;
    }

    if (titleColor == null) {
      _titleColor = ColorUtils.hexToColor('#333333');
    } else {
      _titleColor = titleColor;
    }

    SystemUiOverlayStyle _overlayStyle =
        ThemeData.estimateBrightnessForColor(_backgroundColor) ==
                Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    var back = isBack
        ? onBack == null
            ? IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.maybePop(context).then((value) {
                    if (!value) {
                      SystemNavigator.pop();
                    }
                  });
                },
                tooltip: 'Back',
                icon: Image.asset(
                  backImg,
                  width: 25,
                  height: 25,
                  color: ThemeUtils.getIconColor(context),
                ),
              )
            : IconButton(
                onPressed: onBack,
                tooltip: 'Back',
                icon: Image.asset(
                  backImg,
                  width: 25,
                  height: 25,
                  color: ThemeUtils.getIconColor(context),
                ),
              )
        : Gaps.empty;

    var action = actionName.isNotEmpty
        ? Positioned(
            right: 0.0,
            child: Theme(
              data: Theme.of(context).copyWith(
                  buttonTheme: ButtonThemeData(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                minWidth: 60.0,
              )),
              child: FlatButton(
                child: Text(actionName,
                    key: const Key('actionName'),
                    style: TextStyle(fontSize: Dimens.font_sp14)),
                textColor: ThemeUtils.isDark(context)
                    ? Colours.dark_text
                    : ColorUtils.hexToColor('#2567FE'),
                highlightColor: Colors.transparent,
                onPressed: onPressed,
              ),
            ),
          )
        : Gaps.empty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: _backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Semantics(
                namesRoute: true,
                header: true,
                child: Container(
                  alignment: centerTitle.isEmpty
                      ? Alignment.centerLeft
                      : Alignment.center,
                  width: double.infinity,
                  child: Text(
                    title.isEmpty ? centerTitle : title,
                    style: TextStyle(
                        color: _titleColor, fontSize: Dimens.font_sp18),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 44.0),
                ),
              ),
              back,
              action
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44.0);
}
