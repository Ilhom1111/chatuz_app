import 'package:filebase_chat_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItemHome extends StatelessWidget {
  final Function() onTap;
  final NetworkImage? image;
  final String? avatarText;
  final bool isOnline;
  final String name;
  final DateTime lastActive;
  const UserItemHome({
    super.key,
    required this.onTap,
    this.image,
    this.avatarText,
    required this.isOnline,
    required this.name,
    required this.lastActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
              backgroundColor: const Color(0xff2D3250),
              radius: 24,
              backgroundImage: image,
              child: avatarText != null
                  ? Text(
                      avatarText.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12 * MediaQuery.devicePixelRatioOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null),
          Badge(
            isLabelVisible: isOnline,
            backgroundColor: MyColors.ffF6B17A,
            smallSize: 12,
          ),
        ],
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff2D3250),
        ),
      ),
      subtitle: Text(
        timeago.format(lastActive),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 7 * MediaQuery.devicePixelRatioOf(context),
            color: const Color(0xff7077A1)),
      ),
    );
  }
}
