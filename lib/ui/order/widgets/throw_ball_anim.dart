import 'package:flutter/material.dart';
import 'package:order/ui/order/provider/ball_anim_provider.dart';
import 'package:provider/provider.dart';

//加入购物车抛物线动画
class ThrowBallAnim extends StatefulWidget {
  @override
  _ThrowBallAnimState createState() => _ThrowBallAnimState();
}

class _ThrowBallAnimState extends State<ThrowBallAnim> {
  List<GlobalKey<__BallAnimState>> _ballAnimKeys = [];

  void _startThrowBallAnim() {
    final ballAnimProvider = Provider.of<BallAnimProvider>(context,listen: false);
    //获取小球大小
    final ballSize = ballAnimProvider.ballSize;
    //计算小球的开始位置
    final startPosition = ballAnimProvider.ballPosition;
    // 计算小球的结束位置
    final endPosition = Offset(
      ballAnimProvider.shopCarPosition.dx +
          (ballAnimProvider.shopCarSize.width - ballSize.width) / 2.0,
      ballAnimProvider.shopCarPosition.dy +
          (ballAnimProvider.shopCarSize.height - ballSize.height) / 2.0,
    );

    for (var value in _ballAnimKeys) {
      final _ballAnimState = value.currentState;
      if (_ballAnimState._isHide) {
        // 查找一个没有在执行动画的小球,然后启动动画
        _ballAnimState.startAnim(ballSize, startPosition, endPosition);
        // 中断循环
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < BallAnimProvider.ballCount; i++) {
      _ballAnimKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ballAnimProvider = Provider.of<BallAnimProvider>(context,listen: false);
    //赋值回调
    ballAnimProvider.notifyStartAnim = _startThrowBallAnim;
    return IgnorePointer(
      child: Stack(
        children: _ballAnimKeys.map((key) => _BallAnim(key: key)).toList(),
      ),
    );
  }
}

class _BallAnim extends StatefulWidget {
  _BallAnim({Key key}) : super(key: key);

  @override
  __BallAnimState createState() => __BallAnimState();
}

class __BallAnimState extends State<_BallAnim> with TickerProviderStateMixin {
  bool _isHide;
  Size _ballSize;
  Offset _ballOffset;

  AnimationController _animationController;
  Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    //初始化
    _isHide = true;
    _ballSize = Size.zero;
    _ballOffset = Offset.zero;

    //动画控制器
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束，就立即隐藏小球
        setState(() {
          _isHide = true;
        });
      }
    });
  }

  void startAnim(Size ballSize, Offset startPosition, Offset endPosition) {
    //创建动画执行轨迹
    _animationOffset = ThrowTween(begin: startPosition, end: endPosition)
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              //拿到中间计算值，刷新界面
              _ballOffset = _animationOffset.value;
            });
          });

    //启动动画前 将小球显示出来
    setState(() {
      _isHide = false;
      _ballSize = ballSize;
      _ballOffset = startPosition;
    });

    //然后执行动画
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _ballOffset.dx,
      top: _ballOffset.dy,
      width: _ballSize.width,
      height: _ballSize.height,
      child: Offstage(
        offstage: _isHide,
        child: ClipOval(
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

///抛物线方程表达式 y=ax^2+bx+c
class ThrowTween extends Animatable<Offset> {
  //开始点
  final Offset begin;

  //结束点
  final Offset end;

  double a = 0.0;
  double b = 0.0;
  double c = 0.0;

  ThrowTween({this.begin, this.end}) {
    Offset center = Offset(begin.dx - 5, begin.dy - 5);
    // 已知的三个点
    final x1 = begin.dx;
    final y1 = begin.dy;
    final x2 = center.dx;
    final y2 = center.dy;
    final x3 = end.dx;
    final y3 = end.dy;
    // 中间值
    final temp1 = x2 * x2 - x3 * x3;
    final temp2 = x1 * x1 - x2 * x2;
    // 计算抛物线系数
    b = (temp1 * (y1 - y2) - temp2 * (y2 - y3)) /
        (temp1 * (x1 - x2) - (temp2) * (x2 - x3));
    a = (y1 - y2 - b * (x1 - x2)) / temp2;
    c = y1 - a * x1 * x1 - b * x1;
  }

  double _computed(double x) => a * x * x + b * x + c;

  @override
  Offset transform(double t) {
    // x是一次函数
    final dx = begin.dx + (end.dx - begin.dx) * t;
    final dy = _computed(dx);
    return Offset(dx, dy);
  }
}
