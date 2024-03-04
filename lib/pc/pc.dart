import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../drawer/drawer.dart';

class pcPage extends StatefulWidget {
  @override
  _pcPage createState() => _pcPage();
}

class _pcPage extends State<pcPage> {
  late String accessToken;
  List<Map<String, String>> pcList = [];

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
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          pcList = data
              .map((pc) => {
                    'label_name': pc['label_name'] != null
                        ? pc['label_name'] as String
                        : '',
                    'pc_user':
                        pc['pc_user'] != null ? pc['pc_user'] as String : '',
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
        return Card(
          child: ListTile(
            title: Text(pcList[index]['label_name'] ?? ''),
            subtitle: Text('使用者:${pcList[index]['pc_user'] ?? ''}'),
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
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('ITCPC001'),
              subtitle: Text('使用者：'),
            ),
          ),
        ],
      ),
    );
  }
}
