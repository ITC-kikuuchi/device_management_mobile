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

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * windows詳細取得
   */
  Future<String> _getWindowsDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/windows/${widget.windowsId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          windowsData = json.decode(responseBody);
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching Windows data: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
