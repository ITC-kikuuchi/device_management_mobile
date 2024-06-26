import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_bar/app_bar.dart';
import '../../widgets/detail_item.dart';
import '../../widgets/enforcement_logout_dialog.dart';
import '../../constants.dart';

class PcDetailPage extends StatefulWidget {
  final int pcId;
  PcDetailPage({required this.pcId});
  @override
  _PcDetailPage createState() => _PcDetailPage();
}

class _PcDetailPage extends State<PcDetailPage> {
  late String accessToken;
  Map<String, dynamic> pcData = {};

  /**
   * 画面の初期化
   */
  @override
  void initState() {
    super.initState();
    _InitializePage();
  }

  /**
   * 初期化される際に実行する関数の呼び出し
   */
  Future<void> _InitializePage() async {
    await _GetAccessToken();
    await _GetPcDetail();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _GetAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * pc詳細取得
   */
  Future<String> _GetPcDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/pc/${widget.pcId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == HttpStatusCode.ok) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          pcData = json.decode(responseBody);
        });
      } else if (response.statusCode == HttpStatusCode.unauthorized) {
        // セッション切れの場合、ダイアログを表示
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return EnforcementLogoutDialog();
          },
        );
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
                  pcData['label_name'] ?? '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // PC情報を表示するウィジェット
              DetailItem(label: 'pc名', value: pcData['pc_name'] ?? '-'),
              DetailItem(label: 'ユーザ名', value: pcData['user_name'] ?? '-'),
              DetailItem(label: '使用者', value: pcData['pc_user'] ?? '-'),
              DetailItem(label: '状態', value: pcData['condition'] ?? '-'),
              DetailItem(label: 'メーカー', value: pcData['manufacturer'] ?? '-'),
              DetailItem(label: '型', value: pcData['type'] ?? '-'),
              DetailItem(label: 'サービスタグ', value: pcData['service_tag'] ?? '-'),
              DetailItem(label: 'OS', value: pcData['os'] ?? '-'),
              DetailItem(
                label: 'bit数',
                value: pcData['bit'] != null ? pcData['bit'].toString() : '-',
              ),
              DetailItem(label: 'IE Ver', value: pcData['ie_version'] ?? '-'),
              DetailItem(label: 'IPアドレス', value: pcData['ip_address'] ?? '-'),
              DetailItem(
                  label: 'GX/WWPライセンス', value: pcData['gx_wwp_license'] ?? '-'),
              DetailItem(label: '納品日', value: pcData['delivery_date'] ?? '-'),
              DetailItem(label: '廃棄日', value: pcData['disposal_date'] ?? '-'),
              DetailItem(label: '備考', value: pcData['remarks'] ?? '-'),
            ],
          ),
        ),
      ),
    );
  }
}
