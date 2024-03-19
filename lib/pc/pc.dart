import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';
import '../widgets/last_updated_user.dart';
import '../widgets/card_list.dart';
import '../constants.dart';

class pcPage extends StatefulWidget {
  @override
  _pcPage createState() => _pcPage();
}

class _pcPage extends State<pcPage> {
  late String accessToken;
  late List<Map<String, dynamic>> pcList = [];
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
    await _getPc();
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
   * pc最終更新者取得
   */
  Future<String> _getLastUpdatedUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/pc_update_user'),
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
          CardList(deviceList: pcList, deviceId: DeviceId.pc),
        ],
      ),
    );
  }
}
