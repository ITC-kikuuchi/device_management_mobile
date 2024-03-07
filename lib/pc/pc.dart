import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import '../pc/pc_detail.dart';

class pcPage extends StatefulWidget {
  @override
  _pcPage createState() => _pcPage();
}

class _pcPage extends State<pcPage> {
  late String accessToken;
  late List<Map<String, dynamic>> pcList = [];

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
    await _getPc();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * pc一覧取得
   */
  Future<String> _getPc() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/pc'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        setState(() {
          pcList = data
              .map((pc) => {
                    'id': pc['id'],
                    'label_name': pc['label_name'] != null
                        ? pc['label_name'] as String
                        : '',
                    'pc_user':
                        pc['pc_user'] != null ? pc['pc_user'] as String : '',
                    'delete_flag': pc['delete_flag'] != null
                        ? pc['delete_flag'] as bool
                        : false,
                    'last_updated_flag': pc['last_updated_flag'] != null
                        ? pc['last_updated_flag'] as bool
                        : false,
                  })
              .toList();
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

  /**
   * pc一覧を表示する処理
   */
  Widget _buildPcCards() {
    return ListView.builder(
      itemCount: pcList.length,
      itemBuilder: (context, index) {
        final bool isDeleted =
            pcList[index]['delete_flag'] == true; // delete_flagがtrueかどうかを判定
        final Color cardColor =
            isDeleted ? Color.fromARGB(255, 188, 188, 188) : Colors.white;

        final bool last_updated_flag = pcList[index]['last_updated_flag'] ==
            true; // last_updated_flagがtrueかどうかを判定
        final Color textColor =
            last_updated_flag ? Color.fromARGB(255, 255, 0, 0) : Colors.black;

        return Card(
          color: cardColor,
          child: ListTile(
            title: Text(
              pcList[index]['label_name'] ?? '',
              style: TextStyle(color: textColor), // テキストの色を設定
            ),
            subtitle: Text(
              '使用者:${pcList[index]['pc_user'] ?? ''}',
              style: TextStyle(color: textColor), // テキストの色を設定
            ),
            onTap: () {
              // タップ時の処理
              final pcId = pcList[index]['id']; // idを取得
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: _buildPcCards(),
    );
  }
}
