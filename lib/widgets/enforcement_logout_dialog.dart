import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login/login.dart';

class EnforcementLogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          // 枠線を追加する
          borderRadius: BorderRadius.circular(10.0), // 枠線の角丸を設定
          side: BorderSide(color: const Color.fromARGB(255, 106, 106, 106), width: 3.0), // 枠線の色と幅を設定
        ),
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
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('access_token');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
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
  }
}
