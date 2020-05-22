import 'package:flutter/material.dart';
import 'package:order/entity/sort.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/pages/sub_item_page.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/widgets/md2_tab_indicator.dart';

class SubListPage extends StatefulWidget {
  final List<Sort> data;

  SubListPage({Key key, this.data})
      : super(key: key);

  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: widget.data.length, vsync: this);
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
              fontSize: Dimens.font_sp14, fontWeight: FontWeight.w700),
          labelColor: ColorUtils.hexToColor('#2567FE'),
          unselectedLabelColor: Colours.text_gray,
          isScrollable: true,
          indicator: MD2Indicator(
              indicatorHeight: 3,
              indicatorColor: ColorUtils.hexToColor('#2567FE'),
              indicatorSize: MD2IndicatorSize.normal),
          tabs: widget.data.map((e) => Tab(text: e.typeName)).toList(),
          onTap: (index) {
            if (!mounted) {
              return;
            }
            _pageController.jumpToPage(index);
          },
        ),
        Expanded(
          child: PageView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.data.length,
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
              itemBuilder: (_, index) {
                return SubItemPage(
                  key: Key('subItem${widget.data[index].id}'),
                  id: widget.data[index].id
                );
              }),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }
}
