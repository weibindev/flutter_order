class Constant {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction =
      const bool.fromEnvironment('dart.vm.product');

  static bool isTest = false;

  static const String baseUrl = 'baseUrl';

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String theme = 'AppTheme';

  static const String cartGoods = 'cartGoods';
  static const String sortGoods = 'sortGoods';

  //商品属性
  static const String property = 'property';

  static bool isShowShopList = false;
}
