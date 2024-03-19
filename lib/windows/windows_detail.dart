import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar/app_bar.dart';
import '../widgets/detail_item.dart';

class windowsDetailPage extends StatefulWidget {
  final int windowsId;
  windowsDetailPage({required this.windowsId});
  @override
  _windowsDetailPage createState() => _windowsDetailPage();
}

class _windowsDetailPage extends State<windowsDetailPage> {
  late String accessToken;
  Map<String, dynamic> windowsData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
