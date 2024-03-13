import 'package:flutter/material.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class androidPage extends StatefulWidget {
  @override
  _androidPage createState() => _androidPage();
}

class _androidPage extends State<androidPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
    );
  }
}
