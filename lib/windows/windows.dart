import 'package:flutter/material.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class windowsPage extends StatefulWidget {
  @override
  _windowsPage createState() => _windowsPage();
}

class _windowsPage extends State<windowsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
    );
  }
}
