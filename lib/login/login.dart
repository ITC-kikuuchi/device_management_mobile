import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_bar/app_bar.dart';
import '../pc/pc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    } else {
      // メールアドレスの正規表現を使用して形式をチェック
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return '正しいメールアドレスの形式で入力してください';
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40.0), // ウィジェットの周囲に余白を追加
          child: Form(
            key: _formKey, 
            child: Column(
              // 子要素を垂直方向に配置
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    // テキスト入力フィールドの作成
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'メールアドレス',
                    ),
                    validator: _validateEmail, // バリデーション関数を指定
                    keyboardType:
                        TextInputType.emailAddress, // キーボードタイプをメールアドレス用に指定
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    // テキスト入力フィールドの作成
                    controller: _passwordController,
                    obscureText: _isObscure, // テキストを非表示にするかどうかの設定
                    decoration: InputDecoration(
                        labelText: 'パスワード',
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              // アイコンがタップされた時の処理
                              setState(() {
                                // ステートを更新する
                                _isObscure = !_isObscure;
                              });
                            })),
                    validator: _validatePassword, // バリデーション関数を指定
                  ),
                ),
                Center(
                  // ボタンを画面中央に配置
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ボタンが押下されたら別のページに遷移する
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pcPage()),
                        );
                      }
                    },
                    child: Text('ログイン'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
