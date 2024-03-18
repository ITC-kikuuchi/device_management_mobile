import 'package:flutter/material.dart';

class DetailItem extends StatefulWidget {
  final String label;
  final String value;
  DetailItem({required this.label, required this.value});
  @override
  _DetailItem createState() => _DetailItem();
}

/**
* デバイスを詳細表示する処理
*/
class _DetailItem extends State<DetailItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 5), // 左側に16の余白を追加
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベルを左寄せに配置
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4), // ラベルと値の間隔を設定
          // 値を左寄せに配置
          Text(
            widget.value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
