import 'entity/goods.dart';
import 'entity/property.dart';
import 'entity/sort.dart';
import 'entity/discount_packages.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == 'GoodsBean') {
      return GoodsBean.fromJson(json) as T;
    } else if (T.toString() == 'Property') {
      return Property.fromJson(json) as T;
    } else if (T.toString() == 'Sort') {
      return Sort.fromJson(json) as T;
    } else if (T.toString() == 'DiscountPackages') {
      return DiscountPackages.fromJson(json) as T;
    }
  }
}
