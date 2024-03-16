import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import '../ios/ios_detail.dart';

class iosPage extends StatefulWidget {
  @override
  _iosPage createState() => _iosPage();
}

class _iosPage extends State<iosPage> {
  late String accessToken;
  late List<Map<String, dynamic>> iosList = [];
  Map<String, dynamic> userData = {};

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
    await _getIos();
    await _getLastUpdatedUser();
  }

  /**
   * ログインユーザのトークン取得
   */
  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? "";
  }

  /**
   * ios一覧取得
   */
  Future<String> _getIos() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/ios'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        setState(() {
          iosList = data
              .map((ios) => {
                    'id': ios['id'],
                    'label_name': ios['label_name'] != null
                        ? ios['label_name'] as String
                        : '',
                    'os': ios['os'] != null ? ios['os'] as String : '',
                    'delete_flag': ios['delete_flag'] != null
                        ? ios['delete_flag'] as bool
                        : false,
                    'last_updated_flag': ios['last_updated_flag'] != null
                        ? ios['last_updated_flag'] as bool
                        : false,
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching iOS data: $e');
      return '';
    }
  }

  /**
   * ios最終更新者取得
   */
  Future<String> _getLastUpdatedUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/ios_update_user'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        setState(() {
          userData = json.decode(responseBody);
        });
      } else {
        throw Exception('Failed to load data');
      }
      return '';
    } catch (e) {
      print('Error fetching user data: $e');
      return '';
    }
  }

  /**
   * ios一覧を表示する処理
   */
  Widget _buildIosCards() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: iosList.length,
        itemBuilder: (context, index) {
          final bool isDeleted =
              iosList[index]['delete_flag'] == true; // delete_flagがtrueかどうかを判定
          final Color cardColor =
              isDeleted ? Color.fromARGB(255, 188, 188, 188) : Colors.white;

          final bool last_updated_flag = iosList[index]['last_updated_flag'] ==
              true; // last_updated_flagがtrueかどうかを判定
          final Color textColor =
              last_updated_flag ? Color.fromARGB(255, 255, 0, 0) : Colors.black;

          return Card(
            color: cardColor,
            child: ListTile(
              title: Text(
                iosList[index]['label_name'] ?? '',
                style: TextStyle(color: textColor), // テキストの色を設定
              ),
              subtitle: Text(
                'OS:${iosList[index]['os'] ?? ''}',
                style: TextStyle(color: textColor), // テキストの色を設定
              ),
              onTap: () {
                // タップ時の処理
                final iosId = iosList[index]['id']; // idを取得
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => iosDetailPage(iosId: iosId)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /**
   * ios最終更新者を表示する処理
   */
  Widget _buildLastUpdatedUser() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
      child: Text(
        '最終更新者:${userData['user_name'] ?? ''}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: _buildIosCards(),
    );
  }
}
