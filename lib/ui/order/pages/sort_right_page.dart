import 'package:flutter/material.dart';
import 'package:order/entity/sort.dart';
import 'package:order/ui/order/pages/discount_page.dart';
import 'package:order/ui/order/pages/sub_item_page.dart';
import 'package:order/ui/order/pages/sub_list_page.dart';

class SortRightPage extends StatefulWidget {
  final int parentId;
  final List<Sort> data;

  SortRightPage(
      {Key key,
      this.parentId,
      this.data})
      : super(key: key);

  @override
  _SortRightPageState createState() => _SortRightPageState();
}

class _SortRightPageState extends State<SortRightPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.data == null || widget.data.isEmpty) {
      if (widget.parentId == -1) {
        return DiscountPage();
      } else {
        return SubItemPage(
          key: Key('subItem${widget.parentId}'),
          id: widget.parentId
        );
      }
    } else {
      return SubListPage(
        key: Key('subList${widget.parentId}'),
        data: widget.data
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
