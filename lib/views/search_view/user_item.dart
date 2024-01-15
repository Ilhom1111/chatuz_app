import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../screens/chat_page.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                userId: widget.user.uid,
              ),
            ),
          );
        },
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              backgroundColor: MyColors.ff2D3250,
              radius: 24,
              backgroundImage: widget.user.image != "no image"
                  ? NetworkImage(widget.user.image)
                  : null,
              child: widget.user.image != "no image"
                  ? null
                  : Text(
                      widget.user.name[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11 * MediaQuery.devicePixelRatioOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Badge(
              isLabelVisible: widget.user.isOnline,
              backgroundColor: MyColors.ffF6B17A,
              smallSize: 12,
            ),
          ],
        ),
        title: Text(
          widget.user.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: MyColors.ff2D3250,
          ),
        ),
        subtitle: Text(
          widget.user.email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 7 * MediaQuery.devicePixelRatioOf(context),
              color: MyColors.ff7077A1),
        ),
      );
}
