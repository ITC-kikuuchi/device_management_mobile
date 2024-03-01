import 'package:flutter/material.dart';
import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pcPage extends StatefulWidget {
  @override
  _pcPage createState() => _pcPage();
}

class _pcPage extends State<pcPage> {
  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: FutureBuilder<String>(
          future: getAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              // トークンを画面に表示
              return Text('Access Token: ${snapshot.data}');
            }
            return Text('Access Token not found');
          },
        ),
      ),
    );
  }
}
