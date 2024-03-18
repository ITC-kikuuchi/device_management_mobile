import 'package:flutter/material.dart';

class LastUpdatedUser extends StatefulWidget {
  Map<String, dynamic> userData;
  LastUpdatedUser({required this.userData});
  @override
  _LastUpdatedUser createState() => _LastUpdatedUser();
}

/**
 * 最終更新者を表示
 */
class _LastUpdatedUser extends State<LastUpdatedUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '最終更新者:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: '${widget.userData['user_name'] ?? ''}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
