import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_bar/app_bar.dart';
import '../../drawer/drawer.dart';
import '../../widgets/last_updated_user.dart';
import '../../widgets/card_list.dart';
import '../../widgets/enforcement_logout_dialog.dart';
import '../../constants.dart';

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
      if (response.statusCode == HttpStatusCode.ok) {
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
      } else if (response.statusCode == HttpStatusCode.unauthorized) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'セッション切れのため\nログアウトします',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.grey,
                              elevation: 5,
                              backgroundColor: Colors.blueAccent,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('access_token');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
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
          CardList(deviceList: iosList, deviceId: DeviceId.ios),
        ],
      ),
    );
  }
}
