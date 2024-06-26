import 'package:flutter/material.dart';

import '../pages/pc/pc.dart';
import '../pages/ios/ios.dart';
import '../pages/android/android.dart';
import '../pages/windows/windows.dart';

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
                MaterialPageRoute(builder: (context) => PcPage()), // 遷移先の画面を指定
              );
            },
          ),
          ListTile(
            title: Text("iOS一覧"),
            leading: Icon(Icons.apple),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IosPage()), // 遷移先の画面を指定
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => windowsPage()), // 遷移先の画面を指定
              );
            },
          ),
        ],
      ),
    );
  }
}
