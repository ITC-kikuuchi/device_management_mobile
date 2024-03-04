import 'package:flutter/material.dart';
import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pcPage extends StatefulWidget {
  @override
  _pcPage createState() => _pcPage();
}

class _pcPage extends State<pcPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('ITCPC001'),
              subtitle: Text('使用者：'),
            ),
          ),
        ],
      ),
    );
  }
}
