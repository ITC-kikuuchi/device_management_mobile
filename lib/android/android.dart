import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class androidPage extends StatefulWidget {
  @override
  _androidPage createState() => _androidPage();
}

class _androidPage extends State<androidPage> {
  late String accessToken;
  late List<Map<String, dynamic>> androidList = [];

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
    await _getAndroid();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * Android一覧取得
   */
  Future<String> _getAndroid() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/android'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        setState(() {
          androidList = data
              .map((android) => {
                    'id': android['id'],
                    'label_name': android['label_name'] != null
                        ? android['label_name'] as String
                        : '',
                    'os': android['os'] != null ? android['os'] as String : '',
                    'delete_flag': android['delete_flag'] != null
                        ? android['delete_flag'] as bool
                        : false,
                    'last_updated_flag': android['last_updated_flag'] != null
                        ? android['last_updated_flag'] as bool
                        : false,
                  })
              .toList();
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

  /**
   * Android一覧を表示する処理
   */
  Widget _buildAndroidCards() {
    return ListView.builder(
      itemCount: androidList.length,
      itemBuilder: (context, index) {
        final bool isDeleted = androidList[index]['delete_flag'] ==
            true; // delete_flagがtrueかどうかを判定
        final Color cardColor =
            isDeleted ? Color.fromARGB(255, 188, 188, 188) : Colors.white;

        final bool last_updated_flag = androidList[index]
                ['last_updated_flag'] ==
            true; // last_updated_flagがtrueかどうかを判定
        final Color textColor =
            last_updated_flag ? Color.fromARGB(255, 255, 0, 0) : Colors.black;

        return Card(
          color: cardColor,
          child: ListTile(
            title: Text(
              androidList[index]['label_name'] ?? '',
              style: TextStyle(color: textColor), // テキストの色を設定
            ),
            subtitle: Text(
              'OS:${androidList[index]['os'] ?? ''}',
              style: TextStyle(color: textColor), // テキストの色を設定
            ),
            onTap: () {
              // タップ時の処理
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
    );
  }
}
