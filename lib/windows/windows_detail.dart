import 'package:flutter/material.dart';

import '../app_bar/app_bar.dart';

class windowsDetailPage extends StatefulWidget {
  final int windowsId;
  windowsDetailPage({required this.windowsId});
  @override
  _windowsDetailPage createState() => _windowsDetailPage();
}

class _windowsDetailPage extends State<windowsDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
