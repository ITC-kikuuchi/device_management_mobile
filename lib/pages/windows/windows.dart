import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_bar/app_bar.dart';
import '../../drawer/drawer.dart';
import '../../widgets/last_updated_user.dart';
import '../../widgets/card_list.dart';
import '../../constants.dart';

class windowsPage extends StatefulWidget {
  @override
  _windowsPage createState() => _windowsPage();
}

class _windowsPage extends State<windowsPage> {
  late String accessToken;
  late List<Map<String, dynamic>> windowsList = [];
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
    await _getWindows();
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
   * windows一覧取得
   */
  Future<String> _getWindows() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/windows'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == HttpStatusCode.ok) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        setState(() {
          windowsList = data
              .map((windows) => {
                    'id': windows['id'],
                    'label_name': windows['label_name'] != null
                        ? windows['label_name'] as String
                        : '',
                    'os': windows['os'] != null ? windows['os'] as String : '',
                    'delete_flag': windows['delete_flag'] != null
                        ? windows['delete_flag'] as bool
                        : false,
                    'last_updated_flag': windows['last_updated_flag'] != null
                        ? windows['last_updated_flag'] as bool
                        : false,
                  })
              .toList();
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

  /**
   * windows最終更新者取得
   */
  Future<String> _getLastUpdatedUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/windows_update_user'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == HttpStatusCode.ok) {
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
          CardList(deviceList: windowsList, deviceId: DeviceId.windows),
        ],
      ),
    );
  }
}
