import 'package:flutter/material.dart';
import 'package:order/widgets/state_layout.dart';
import 'package:order/widgets/tool_bar.dart';

class WidgetNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Toolbar(
        centerTitle: '页面不存在',
      ),
      body: StateLayout(
        type: StateType.network,
        hintText: '页面不存在',
      ),
    );
  }
}
