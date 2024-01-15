import 'dart:developer';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:filebase_chat_app/constants/colors.dart';
import 'package:filebase_chat_app/screens/video_call_pages/call_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message_model.dart';
import '../models/user.dart';
import '../provider/firebase_provider.dart';
import '../services/firebase/firebase_firestore_service.dart';
import '../services/firebase/media_service.dart';
import '../services/firebase/notification_service.dart';
import '../views/chat_view/chat_avatar.dart';
import '../views/chat_view/his_chat.dart';
import '../views/chat_view/my_chat.dart';
import '../views/chat_view/user_name_nli_ofli.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  const ChatPage({super.key, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  final String myName = FirebaseAuth.instance.currentUser!.displayName!;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  final notificationsService = NotificationsService();
  String receiverId = '';
  Uint8List? file;

  @override
  void initState() {
    receiverId = widget.userId;
    notificationsService.getReceiverToken(receiverId);
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId)
      ..getMyInfo(myUid);
    super.initState();
  }

  void sendText(BuildContext context, bool tf, String uid, UserModel myInfo,
      UserModel userInfo) async {
    List<String> mylist = [];
    List<String> userlist = [];
    mylist = myInfo.myPeople;
    userlist = userInfo.myPeople;
    if (controller.text.isNotEmpty) {
      if (mylist.contains(uid)) {
        await FirebaseFirestoreService.addTextMessage(
          receiverId: receiverId,
          content: controller.text,
        );
      } else {
        mylist.add(uid);
        userlist.add(myUid);
        FirebaseFirestoreService.updatemyPeopleData(
            {'myPeople': mylist}, myUid);
        FirebaseFirestoreService.updatemyPeopleData(
            {'myPeople': userlist}, uid);
        await FirebaseFirestoreService.addTextMessage(
          receiverId: receiverId,
          content: controller.text,
        );
      }

      if (tf == false) {
        await notificationsService.sendNotification(
          title: myName,
          body: controller.text,
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
      }

      controller.clear();
    }
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  void sendImage(bool tf) async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: receiverId,
        file: file!,
      );
      if (tf == false) {
        await notificationsService.sendNotification(
          title: myName,
          body: 'Sent you a picture',
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.ff7077A1.withOpacity(.1),
        toolbarHeight: 65,
        leadingWidth: 65,
        elevation: .0,
        leading: Padding(
            padding: const EdgeInsets.all(7),
            child: Consumer<FirebaseProvider>(builder: (context, value, child) {
              return value.user != null
                  ? ChatAvatar(
                      image: value.user!.image,
                      name: value.user!.image != "no image"
                          ? null
                          : value.user!.name[0],
                    )
                  : const SizedBox();
            })),
        title: Consumer<FirebaseProvider>(builder: (context, value, child) {
          return value.user != null
              ? UserNameOnliOfli(
                  name: value.user!.name, isOnline: value.user!.isOnline)
              : const SizedBox();
        }),
        actions: [
          Consumer<FirebaseProvider>(
            builder: (context, value, child) => value.messages.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      String callId =
                          "${value.messages.first.receiverId}${value.messages.first.senderId}";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallPage(
                            callID: callId,
                            userName: myName,
                            userId: myUid,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.videocam,
                      color: MyColors.ff2D3250,
                    ))
                : const SizedBox(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.ff7077A1.withOpacity(.1),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Consumer<FirebaseProvider>(
              builder: (context, value, child) => value.messages.isEmpty
                  ? Center(
                      child: FittedBox(
                        child: Text(
                          "Chat not available!",
                          style: TextStyle(
                            fontSize:
                                10 * MediaQuery.devicePixelRatioOf(context),
                            color: MyColors.ff2D3250,
                            fontWeight: FontWeight.w600,
                          ),
                        ).tr(),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 18,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ListView.builder(
                              controller: Provider.of<FirebaseProvider>(context,
                                      listen: false)
                                  .scrollController,
                              itemCount: value.messages.length,
                              itemBuilder: (context, index) {
                                log(receiverId);
                                final mes = value.messages[index];
                                final isMe = receiverId != mes.senderId;
                                final isImage =
                                    mes.messageType == MessageType.text;
                                if (isMe) {
                                  return MyChat(
                                    isImage: isImage,
                                    msg: mes.content,
                                    time: mes.sentTime,
                                  );
                                } else {
                                  return HisChat(
                                    time: mes.sentTime,
                                    isImage: isImage,
                                    msg: mes.content,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 68),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    hintText: "send message".tr(),
                    hintStyle: TextStyle(color: MyColors.ff7077A1),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 204, 206, 219),
                    suffixIcon: Consumer<FirebaseProvider>(
                      builder: (context, value, child) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              splashRadius: 1,
                              onPressed: () {
                                sendText(
                                    context,
                                    value.user!.isOnline,
                                    value.user!.uid,
                                    value.myInfo!,
                                    value.user!);
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: MyColors.ff2D3250,
                              )),
                          IconButton(
                              splashRadius: 1,
                              onPressed: () {
                                sendImage(value.user!.isOnline);
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: MyColors.ff2D3250,
                              )),
                        ],
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
