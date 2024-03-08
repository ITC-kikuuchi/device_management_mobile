import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';

class pcDetailPage extends StatefulWidget {
  final int pcId;
  pcDetailPage({required this.pcId});
  @override
  _pcDetailPage createState() => _pcDetailPage();
}

// PC情報を表示するウィジェット
class PCInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const PCInfoItem({
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


class _pcDetailPage extends State<pcDetailPage> {
  late String accessToken;
  Map<String, dynamic> pcData = {};

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
    await _getPcDetail();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * pc詳細取得
   */
  Future<String> _getPcDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/pc/${widget.pcId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          pcData = json.decode(responseBody);
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching PC data: $e');
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
                  'ITCPC001',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // PC情報を表示するウィジェット
              PCInfoItem(label: 'pc名', value: 'ITCPC001'),
              PCInfoItem(label: 'ユーザ名', value: 'itcowork'),
              PCInfoItem(label: '使用者', value: '-'),
              PCInfoItem(label: '状態', value: '部品取り'),
              PCInfoItem(label: 'メーカー', value: 'DELL'),
              PCInfoItem(label: '型', value: 'Vostro3560'),
              PCInfoItem(label: 'サービスタグ', value: 'HQ281X1'),
              PCInfoItem(label: 'OS', value: 'Windows 7 SP1'),
              PCInfoItem(label: 'bit数', value: '64'),
              PCInfoItem(label: 'IE Ver', value: '-'),
              PCInfoItem(label: 'IPアドレス', value: '-'),
              PCInfoItem(label: 'GX/WWPライセンス', value: '-'),
              PCInfoItem(label: '納品日', value: '-'),
              PCInfoItem(label: '廃棄日', value: '-'),
              PCInfoItem(label: '備考', value: '-'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: pcDetailPage(),
  ));
}
