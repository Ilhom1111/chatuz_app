import 'package:filebase_chat_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'zoom_image.dart';

class HisChat extends StatelessWidget {
  final DateTime time;
  final String msg;
  final bool isImage;
  const HisChat(
      {super.key,
      required this.msg,
      required this.isImage,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const ShapeDecoration(
                color: Color.fromARGB(255, 200, 204, 228),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              child: isImage != true
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZoomImage(image: msg),
                          ),
                        );
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            msg,
                          )),
                    )
                  : Text(
                      msg,
                      style: TextStyle(
                        color: MyColors.ff2D3250,
                        fontSize: 7 * MediaQuery.devicePixelRatioOf(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: DateFormat.Hm().format(time),
                  style: const TextStyle(
                    color: MyColors.ff7077A1,
                  ),
                ),
                TextSpan(
                  text: " ${DateFormat("EEEE d").format(time)}",
                  style: TextStyle(
                    color: MyColors.ff7077A1.withOpacity(.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
