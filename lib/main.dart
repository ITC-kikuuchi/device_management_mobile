import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '機器管理システム',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
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
              ),
              ListTile(
                title: Text("iOS一覧"),
                leading: Icon(Icons.apple),
              ),
              ListTile(
                title: Text("Android一覧"),
                leading: Icon(Icons.android),
              ),
              ListTile(
                title: Text("Windows一覧"),
                leading: Icon(Icons.tablet_android),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
