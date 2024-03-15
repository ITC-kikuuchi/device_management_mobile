import 'package:flutter/material.dart';

import '../pc/pc.dart';
import '../ios/ios.dart';
import '../android/android.dart';
import '../windows/windows.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '管理一覧',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("PC一覧"),
            leading: Icon(Icons.computer),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pcPage()), // 遷移先の画面を指定
              );
            },
          ),
          ListTile(
            title: Text("iOS一覧"),
            leading: Icon(Icons.apple),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => iosPage()), // 遷移先の画面を指定
              );
            },
          ),
          ListTile(
            title: Text("Android一覧"),
            leading: Icon(Icons.android),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => androidPage()), // 遷移先の画面を指定
              );
            },
          ),
          ListTile(
            title: Text("Windows一覧"),
            leading: Icon(Icons.tablet_android),
          ),
        ],
      ),
    );
  }
}
