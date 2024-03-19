import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import '../widgets/last_updated_user.dart';
import '../widgets/card_list.dart';
import '../constants.dart';

class windowsPage extends StatefulWidget {
  @override
  _windowsPage createState() => _windowsPage();
}

class _windowsPage extends State<windowsPage> {
  late String accessToken;
  late List<Map<String, dynamic>> windowsList = [];
  Map<String, dynamic> userData = {};

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
    await _getWindows();
    await _getLastUpdatedUser();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
    );
  }
}
