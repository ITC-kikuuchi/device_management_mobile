import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../widgets/detail_item.dart';

class windowsDetailPage extends StatefulWidget {
  final int windowsId;
  windowsDetailPage({required this.windowsId});
  @override
  _windowsDetailPage createState() => _windowsDetailPage();
}

class _windowsDetailPage extends State<windowsDetailPage> {
  late String accessToken;
  Map<String, dynamic> windowsData = {};

  /**
   * 画面の初期化
   */
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  /**
   * 初期化される際に実行する関数の呼び出し
   */
  Future<void> _initializePage() async {
    await _getAccessToken();
    await _getWindowsDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
