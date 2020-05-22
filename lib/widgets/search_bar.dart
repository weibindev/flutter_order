import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:order/res/resources.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/util/theme_utils.dart';

import 'load_image.dart';

///搜索页的AppBar
class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar(
      {Key key,
      this.hintText: '',
      this.backImg: 'assets/images/ic_back_black.png',
      this.isSearch = true,
      this.onTouch,
      this.onSearch,
      this.onPressed,
      this.actionName = '',
      this.actionColor,
      this.isAutoFocus = false,
      this.isAutoSearch = true,
      this.onBack})
      : super(key: key);

  final String backImg;
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback onPressed;
  final VoidCallback onBack;
  final VoidCallback onTouch;
  final bool isSearch;
  final String actionName;
  final Color actionColor;
  final bool isAutoFocus; //是否自动获取焦点
  final bool isAutoSearch; //是否自动搜索

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(44.0);
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    _controller.addListener(_search);
  }

  void _search() {
    String searchText = _controller.text;
    setState(() {
      if (searchText.isEmpty) {
        _hasText = false;
        widget.onSearch('');
      } else {
        _hasText = true;
        widget.onSearch(searchText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtils.isDark(context);
    SystemUiOverlayStyle overlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    Color iconColor = isDark ? Colours.dark_text_gray : Colours.text_gray_c;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: ThemeUtils.getBackgroundColor(context),
        child: SafeArea(
          child: Container(
            child: Row(
              children: <Widget>[
                Semantics(
                  label: '返回',
                  child: SizedBox(
                    width: 30.0,
                    height: 44.0,
                    child: GestureDetector(
                      onTap: widget.onBack == null
                          ? () {
                              FocusScope.of(context).unfocus();
                              Navigator.maybePop(context);
                            }
                          : widget.onBack,
                      child: Padding(
                        key: const Key('search_back'),
                        padding: const EdgeInsets.fromLTRB(2.5, 9.5, 2.5, 9.5),
                        child: Image.asset(
                          widget.backImg,
                          color: isDark ? Colours.dark_text : Colours.text,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: widget.isSearch
                      ? _buildSearch(isDark, iconColor)
                      : _buildTouch(isDark, iconColor),
                ),
                Gaps.hGap10,
                Visibility(
                  visible: widget.actionName.isNotEmpty,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      buttonTheme: ButtonThemeData(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        height: 44.0,
                        minWidth: 42.0,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    child: FlatButton(
                      textColor:
                          isDark ? Colours.dark_button_text : Colors.white,
                      color: Colors.transparent,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        widget.onPressed();
                      },
                      child: Text('${widget.actionName}',
                          style: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: widget.actionColor ??
                                  ColorUtils.hexToColor('#2567FE'))),
                    ),
                  ),
                ),
                Gaps.hGap10,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch(bool isDark, Color iconColor) {
    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        color: isDark ? Colours.dark_material_bg : Colours.bg_gray,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: TextField(
        key: const Key('search_text_field'),
        autofocus: widget.isAutoFocus,
        controller: _controller,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          FocusScope.of(context).unfocus();
          //点击软键盘的动作按钮时的回调
          if (widget.isAutoSearch) {
            widget.onSearch(val);
          } else {
            widget.onPressed();
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
                top: 0.0, left: -13.5, right: -16.0, bottom: 14.0),
            border: InputBorder.none,
            icon: Padding(
              padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, left: 4.5),
              child: LoadAssetImage(
                'order_search',
                color: iconColor,
              ),
            ),
            hintText: widget.hintText,
            hintStyle:
                TextStyle(fontSize: Dimens.font_sp12, color: Colours.text_gray),
            suffixIcon: Opacity(
              opacity: _hasText ? 1 : 0,
              child: GestureDetector(
                child: Semantics(
                  label: '清空',
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 8.0, bottom: 8.0),
                    child:
                        LoadAssetImage('order_delete', color: iconColor),
                  ),
                ),
                onTap: () {
                  /// https://github.com/flutter/flutter/issues/36324
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    _controller.text = '';
                    widget.onSearch('');
                  });
                },
              ),
            )),
      ),
    );
  }

  Widget _buildTouch(bool isDark, Color iconColor) {
    return GestureDetector(
      onTap: widget.onTouch,
      child: Container(
        height: 32.0,
        decoration: BoxDecoration(
          color: isDark ? Colours.dark_material_bg : Colours.bg_gray,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Gaps.hGap5,
            LoadAssetImage(
              'order_search',
              color: iconColor,
              width: 17,
              height: 17,
            ),
            Text(widget.hintText,
                style: TextStyle(
                    fontSize: Dimens.font_sp12, color: Colours.text_gray))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
