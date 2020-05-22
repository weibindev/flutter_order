import 'package:flutter/material.dart';

class BallAnimProvider extends ChangeNotifier {
  //能显示的小球的总个数
  static int ballCount = 10;

  Size _ballSize = Size.zero;

  set ballSize(Size ballSize) {
    this._ballSize = ballSize;
  }

  Size get ballSize => _ballSize;

  // 小球位置
  Offset _ballPosition = Offset.zero;

  set ballPosition(Offset ballPosition) {
    this._ballPosition = ballPosition;
  }

  Offset get ballPosition => _ballPosition;

  // 购物车大小
  Size _shopCarSize = Size.zero;

  set shopCarSize(Size shopCarSize) {
    this._shopCarSize = shopCarSize;
  }

  Size get shopCarSize => _shopCarSize;

  // 购物车位置
  Offset _shopCarPosition = Offset.zero;

  set shopCarPosition(Offset shopCarPosition) {
    this._shopCarPosition = shopCarPosition;
  }

  Offset get shopCarPosition => _shopCarPosition;

  // 指定动画的回调
  VoidCallback _notifyStartAnim = () {};

  set notifyStartAnim(VoidCallback voidCallback) {
    this._notifyStartAnim = voidCallback;
  }

  VoidCallback get notifyStartAnim => _notifyStartAnim;
}
