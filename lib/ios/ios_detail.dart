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
