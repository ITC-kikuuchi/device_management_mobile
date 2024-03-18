import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import '../widgets/last_updated_user.dart';
import '../widgets/card_list.dart';

class androidPage extends StatefulWidget {
  @override
  _androidPage createState() => _androidPage();
}

class _androidPage extends State<androidPage> {
  late String accessToken;
  late List<Map<String, dynamic>> androidList = [];
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
    await _getAndroid();
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
   * android最終更新者取得
   */
  Future<String> _getLastUpdatedUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/android_update_user'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LastUpdatedUser(userData: userData),
          _buildAndroidCards(),
        ],
      ),
    );
  }
}
