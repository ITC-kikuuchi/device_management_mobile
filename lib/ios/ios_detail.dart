import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';

class iosDetailPage extends StatefulWidget {
  final int iosId;
  iosDetailPage({required this.iosId});
  @override
  _iosDetailPage createState() => _iosDetailPage();
}

// ios情報を表示するウィジェット
class IosInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const IosInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 5), // 左側に16の余白を追加
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベルを左寄せに配置
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4), // ラベルと値の間隔を設定
          // 値を左寄せに配置
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _iosDetailPage extends State<iosDetailPage> {
  late String accessToken;
  Map<String, dynamic> iosData = {};

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
    await _getIosDetail();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * iOS詳細取得
   */
  Future<String> _getIosDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/ios/${widget.iosId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          iosData = json.decode(responseBody);
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching IOS data: $e');
      return '';
    }
  }
}
