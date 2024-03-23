import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login/login.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        '機器管理システム',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout, // ログアウトアイコンを指定します
            color: Colors.white,
          ),
          onPressed: () async {
            // SharedPreferencesの値を初期化
            _showDialog(context);
          },
        ),
      ],
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/**
 * ログイン画面専用 AppBar 
 */
class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        '機器管理システム',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: const Color.fromARGB(255, 106, 106, 106), width: 3.0),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '本当にログアウトしますか？',
                  style: TextStyle(
                    fontSize: 16.0, // 文字サイズを変更
                    fontWeight: FontWeight.bold, // 太さを変更
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.blueAccent,
                        ),
                        shadowColor: Colors.grey,
                        elevation: 5,
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'いいえ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 5,
                        backgroundColor: Colors.blueAccent,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('access_token');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'はい',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
}
