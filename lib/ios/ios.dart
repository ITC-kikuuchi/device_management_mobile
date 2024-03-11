import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class iosPage extends StatefulWidget {
  @override
  _iosPage createState() => _iosPage();
}

class _iosPage extends State<iosPage> {
  late String accessToken;
  late List<Map<String, dynamic>> iosList = [];

  /**
   * 画面の初期化
   */
  @override
  void initState() {
    super.initState();
    _initializePage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
    );
  }
}
