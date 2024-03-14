import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class androidPage extends StatefulWidget {
  @override
  _androidPage createState() => _androidPage();
}

class _androidPage extends State<androidPage> {
  late String accessToken;
  late List<Map<String, dynamic>> androidList = [];

  /**
   * 画面の初期化
   */
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _getAccessToken();
    await _getAndroid();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
    );
  }
}
