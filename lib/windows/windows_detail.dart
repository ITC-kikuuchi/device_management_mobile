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
      body: SingleChildScrollView(
        // SingleChildScrollViewでラップ
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 8),
                child: Text(
                  windowsData['label_name'] ?? '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Windows情報を表示するウィジェット
              DetailItem(label: 'windows名', value: windowsData['windows_name'] ?? '-'),
              DetailItem(label: 'メーカー', value: windowsData['manufacturer'] ?? '-'),
              DetailItem(label: '型', value: windowsData['type'] ?? '-'),
              DetailItem(label: 'OS', value: windowsData['os'] ?? '-'),
              DetailItem(label: 'キャリア', value: windowsData['carrier'] ?? '-'),
              DetailItem(label: '状態', value: windowsData['condition'] ?? '-'),
              DetailItem(label: '納品日', value: windowsData['delivery_date'] ?? '-'),
              DetailItem(label: '廃棄日', value: windowsData['disposal_date'] ?? '-'),
              DetailItem(label: '備考', value: windowsData['remarks'] ?? '-'),
            ],
          ),
        ),
      ),
    );
  }
}
