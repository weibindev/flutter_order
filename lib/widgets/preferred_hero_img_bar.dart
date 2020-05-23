import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/theme_utils.dart';
import 'load_image.dart';

class PreferredHeroImgBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Object tag;
  final String imageUrl;

  PreferredHeroImgBar({Key key, @required this.tag, @required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: tag,
          child: LoadImage(
            imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Semantics(
            namesRoute: true,
            header: true,
            child: IconButton(
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
                'assets/images/ic_back_black.png',
                width: 25,
                height: 25,
                color: ThemeUtils.getIconColor(context),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(375.0);
}