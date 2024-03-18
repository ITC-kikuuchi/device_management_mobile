import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../widgets/detail_item.dart';

class androidDetailPage extends StatefulWidget {
  final int androidId;
  androidDetailPage({required this.androidId});
  @override
  _androidDetailPage createState() => _androidDetailPage();
}

class _androidDetailPage extends State<androidDetailPage> {
  late String accessToken;
  Map<String, dynamic> androidData = {};

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
    await _getAndroidDetail();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * Android詳細取得
   */
  Future<String> _getAndroidDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/android/${widget.androidId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          androidData = json.decode(responseBody);
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching Android data: $e');
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
                  androidData['label_name'] ?? '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Android情報を表示するウィジェット
              DetailItem(label: 'Android名', value: androidData['android_name'] ?? '-'),
              DetailItem(label: 'メーカー', value: androidData['manufacturer'] ?? '-'),
              DetailItem(label: '型', value: androidData['type'] ?? '-'),
              DetailItem(label: 'OS', value: androidData['os'] ?? '-'),
              DetailItem(label: 'キャリア', value: androidData['carrier'] ?? '-'),
              DetailItem(label: '状態', value: androidData['condition'] ?? '-'),
              DetailItem(label: '納品日', value: androidData['delivery_date'] ?? '-'),
              DetailItem(label: '廃棄日', value: androidData['disposal_date'] ?? '-'),
              DetailItem(label: '備考', value: androidData['remarks'] ?? '-'),
            ],
          ),
        ),
      ),
    );
  }
}
