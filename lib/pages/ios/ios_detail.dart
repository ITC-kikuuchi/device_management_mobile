import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_bar/app_bar.dart';
import '../../widgets/detail_item.dart';
import '../../widgets/enforcement_logout_dialog.dart';
import '../../constants.dart';

class IosDetailPage extends StatefulWidget {
  final int iosId;
  IosDetailPage({required this.iosId});
  @override
  _IosDetailPage createState() => _IosDetailPage();
}

class _IosDetailPage extends State<IosDetailPage> {
  late String accessToken;
  Map<String, dynamic> iosData = {};

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
    await _GetIosDetail();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _GetAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * iOS詳細取得
   */
  Future<String> _GetIosDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/ios/${widget.iosId}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == HttpStatusCode.ok) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          iosData = json.decode(responseBody);
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
      print('Error fetching IOS data: $e');
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
                  iosData['label_name'] ?? '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // iOS情報を表示するウィジェット
              DetailItem(label: 'ios名', value: iosData['ios_name'] ?? '-'),
              DetailItem(label: 'メーカー', value: iosData['manufacturer'] ?? '-'),
              DetailItem(label: '型', value: iosData['type'] ?? '-'),
              DetailItem(label: 'OS', value: iosData['os'] ?? '-'),
              DetailItem(label: 'キャリア', value: iosData['carrier'] ?? '-'),
              DetailItem(label: '状態', value: iosData['condition'] ?? '-'),
              DetailItem(label: '納品日', value: iosData['delivery_date'] ?? '-'),
              DetailItem(label: '廃棄日', value: iosData['disposal_date'] ?? '-'),
              DetailItem(label: '備考', value: iosData['remarks'] ?? '-'),
            ],
          ),
        ),
      ),
    );
  }
}
