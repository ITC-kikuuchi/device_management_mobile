import 'package:flutter/material.dart';
import '../app_bar/app_bar.dart';
import '../pc/pc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40.0), // ウィジェットの周囲に余白を追加
          child: Column(
            // 子要素を垂直方向に配置
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  // テキスト入力フィールドの作成
                  decoration: const InputDecoration(
                    labelText: 'メールアドレスを入力してください',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  // テキスト入力フィールドの作成
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
                ),
              ),
              Center(
                // ボタンを画面中央に配置
                child: ElevatedButton(
                  onPressed: () {
                    // ボタンが押下されたら別のページに遷移する
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pcPage()),
                    );
                  },
                  child: Text('ログイン'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
