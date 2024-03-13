import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';

class iosDetailPage extends StatefulWidget {
  final int iosId;
  iosDetailPage({required this.iosId});
  @override
  _iosDetailPage createState() => _iosDetailPage();
}

// ios情報を表示するウィジェット
class IosInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const IosInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 5), // 左側に16の余白を追加
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベルを左寄せに配置
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4), // ラベルと値の間隔を設定
          // 値を左寄せに配置
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _iosDetailPage extends State<iosDetailPage> {
  late String accessToken;
  Map<String, dynamic> iosData = {};
}
