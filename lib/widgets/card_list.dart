import 'package:flutter/material.dart';

import '../pc/pc_detail.dart';
import '../ios/ios_detail.dart';
import '../android/android_detail.dart';

class CardList extends StatefulWidget {
  late List<Map<String, dynamic>> deviceList;
  final int deviceId;
  CardList({required this.deviceList, required this.deviceId});
  @override
  _CardList createState() => _CardList();
}

/**
* デバイスを一覧表示する処理
*/
class _CardList extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.deviceList.length,
        itemBuilder: (context, index) {
          final bool isDeleted = widget.deviceList[index]['delete_flag'] ==
              true; // delete_flagがtrueかどうかを判定
          final Color cardColor =
              isDeleted ? Color.fromARGB(255, 188, 188, 188) : Colors.white;

          final bool last_updated_flag = widget.deviceList[index]
                  ['last_updated_flag'] ==
              true; // last_updated_flagがtrueかどうかを判定
          final Color textColor =
              last_updated_flag ? Color.fromARGB(255, 255, 0, 0) : Colors.black;

          return Card(
            color: cardColor,
            child: ListTile(
              title: Text(
                widget.deviceList[index]['label_name'] ?? '',
                style: TextStyle(color: textColor), // テキストの色を設定
              ),
              subtitle: widget.deviceId == 1
                  ? Text(
                      '使用者: ${widget.deviceList[index]['pc_user']}',
                      style: TextStyle(color: textColor),
                    )
                  : Text(
                      'OS: ${widget.deviceList[index]['os']}',
                      style: TextStyle(color: textColor),
                    ),
              onTap: () {
                // タップ時の処理
                final id = widget.deviceList[index]['id']; // idを取得
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (widget.deviceId) {
                        case 1:
                          return pcDetailPage(pcId: id);
                        case 2:
                          return iosDetailPage(iosId: id);
                        case 3:
                          return androidDetailPage(androidId: id);
                        default:
                          throw Exception(
                              'Invalid device ID: ${widget.deviceId}');
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}