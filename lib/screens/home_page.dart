import 'package:filebase_chat_app/constants/colors.dart';
import 'package:filebase_chat_app/provider/firebase_provider.dart';
import 'package:filebase_chat_app/screens/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase/auth_service/auth_service.dart';
import '../services/firebase/firebase_firestore_service.dart';
import '../services/firebase/notification_service.dart';
import '../views/home_view/profile_image.dart';
import '../views/home_view/user_item_hp.dart';
import 'profile_pages/profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final myUid = FirebaseAuth.instance.currentUser!.uid;
  final myName = FirebaseAuth.instance.currentUser!.displayName;
  final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getAllUsers()
      ..getMyInfo(myUid);
    FirebaseFirestoreService.updateUserData({
      'lastActive': DateTime.now(),
      'isOnline': true,
    }, myUid);
  }

  @override
  void didChangeDependencies() {
    notificationService.firebaseNotification(context);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        }, myUid);
        break;

      case AppLifecycleState.inactive:
        FirebaseFirestoreService.updateUserData({'isOnline': false}, myUid);
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData({'isOnline': false}, myUid);
        break;

      case AppLifecycleState.hidden:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .0,
        backgroundColor: MyColors.ff7077A1.withOpacity(.1),
        title: const Text(
          'ChatUz',
          style: TextStyle(
            color: MyColors.ff2D3250,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(7.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    uId: myUid,
                  ),
                ),
              );
            },
            child: ProfileImageHome(
              image: AuthService.user.photoURL == null
                  ? null
                  : NetworkImage(AuthService.user.photoURL.toString()),
              text: AuthService.user.photoURL == null
                  ? "${AuthService.user.displayName![0]}${AuthService.user.displayName![1]}"
                  : null,
            ),
          ),
        ),
        leadingWidth: 65,
        toolbarHeight: 70,
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UsersSearchScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: MyColors.ff2D3250,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.ff7077A1.withOpacity(.1),
        child: Consumer<FirebaseProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.users.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final user = value.users[index];
                return user.uid != myUid &&
                        value.myInfo!.myPeople.contains(user.uid)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserItemHome(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      userId: user.uid,
                                    ),
                                  ),
                                );
                              },
                              image: user.image != "no image"
                                  ? NetworkImage(user.image)
                                  : null,
                              avatarText: user.image != "no image"
                                  ? null
                                  : user.name[0],
                              isOnline: user.isOnline,
                              name: user.name,
                              lastActive: user.lastActive),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: MyColors.ff7077A1.withOpacity(.2),
                            ),
                          )
                        ],
                      )
                    : const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
