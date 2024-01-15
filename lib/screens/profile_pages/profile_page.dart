import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:filebase_chat_app/constants/colors.dart';
import 'package:filebase_chat_app/views/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../provider/firebase_provider.dart';
import '../../services/firebase/auth_service/auth_service.dart';
import '../../services/firebase/firebase_firestore_service.dart';
import '../../services/firebase/firebase_storage_service.dart';
import '../../views/profile_view/category.dart';
import '../auth_pages/sign_in_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final String uId;
  const ProfilePage({super.key, required this.uId});

  @override
  State<ProfilePage> createState() => ProfilePageStatePage();
}

class ProfilePageStatePage extends State<ProfilePage> {
  final myUid = FirebaseAuth.instance.currentUser!.uid;
  String imageUrl = '';
  File? file;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getMyInfo(widget.uId);
    super.initState();
  }

  Future<void> getImage() async {
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    file = xFile != null ? File(xFile.path) : null;
    if (file != null) {
      if (AuthService.user.photoURL != null) {
        FirebaseStorageService.removeFile(AuthService.user.photoURL!);
      }
      imageUrl = await FirebaseStorageService.uploadFile(file!);
      AuthService.user.updatePhotoURL(imageUrl);
    }
    FirebaseFirestoreService.updateUserData({
      "image": imageUrl,
    }, AuthService.user.uid);
  }

  void showWarningDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              FirebaseFirestoreService.deleteUserData(myUid);
              Navigator.of(context).pop();
              if (ctx.mounted) {
                Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SignInPage()));
              }
            }

            if (state is AuthFailure) {
              Navigator.of(context).pop();
              Navigator.of(ctx).pop();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                AlertDialog(
                  shadowColor: MyColors.ff424769.withOpacity(.15),
                  backgroundColor: const Color.fromARGB(255, 180, 186, 216),
                  title: Center(
                    child: Text(
                      "Delete account",
                      style: TextStyle(
                          fontSize:
                              9.5 * MediaQuery.devicePixelRatioOf(context),
                          color: MyColors.ff2D3250,
                          fontWeight: FontWeight.w600),
                    ).tr(),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state is DeleteConfirmSuccess
                            ? "Enter the password".tr()
                            : "Do you want to open an account?".tr(),
                        style: TextStyle(
                            fontSize:
                                7.5 * MediaQuery.devicePixelRatioOf(context),
                            color: MyColors.ff2D3250,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      if (state is DeleteConfirmSuccess)
                        TextField(
                          controller: controller,
                          style: const TextStyle(
                            color: MyColors.ff2D3250,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration:
                              InputDecoration(hintText: "Password".tr()),
                        ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.ff2D3250),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Text("Cancel", style: TextStyle(color: Colors.white))
                              .tr(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.ff2D3250),
                      onPressed: () {
                        if (state is DeleteConfirmSuccess) {
                          context
                              .read<AuthBloc>()
                              .add(DeleteAccountEvent(controller.text.trim()));
                        } else {
                          context
                              .read<AuthBloc>()
                              .add(const DeleteConfirmEvent());
                        }
                      },
                      child: Text(
                          state is DeleteConfirmSuccess
                              ? "Delete".tr()
                              : "Yes".tr(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                if (state is AuthLoading)
                  const Center(
                    child: Loading(),
                  )
              ],
            );
          },
        );
      },
    );
  }

  void showNameEditDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          shadowColor: MyColors.ff424769.withOpacity(.15),
          backgroundColor: const Color.fromARGB(255, 180, 186, 216),
          title: Center(
            child: Text(
              "Update name",
              style: TextStyle(
                  fontSize: 9.5 * MediaQuery.devicePixelRatioOf(context),
                  color: MyColors.ff2D3250,
                  fontWeight: FontWeight.w600),
            ).tr(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter a new name",
                style: TextStyle(
                    fontSize: 7.5 * MediaQuery.devicePixelRatioOf(context),
                    color: MyColors.ff2D3250,
                    fontWeight: FontWeight.w500),
              ).tr(),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                style: const TextStyle(
                  color: MyColors.ff2D3250,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(hintText: "Name".tr()),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: MyColors.ff2D3250),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.white))
                  .tr(),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: MyColors.ff2D3250),
              onPressed: () {
                if (controller.text.trim() != "") {
                  AuthService.user.updateDisplayName(controller.text.trim());
                  FirebaseFirestoreService.updateUserData({
                    "name": controller.text.trim(),
                  }, AuthService.user.uid);
                  Navigator.pop(context);
                  controller.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Enter a new name").tr()));
                }
              },
              child:
                  const Text("Storage", style: TextStyle(color: Colors.white))
                      .tr(),
            ),
          ],
        );
      },
    );
  }

  void showContactDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          shadowColor: MyColors.ff424769.withOpacity(.15),
          backgroundColor: const Color.fromARGB(255, 180, 186, 216),
          title: Center(
            child: Text(
              "Contact us",
              style: TextStyle(
                  fontSize: 9.5 * MediaQuery.devicePixelRatioOf(context),
                  color: MyColors.ff2D3250,
                  fontWeight: FontWeight.w600),
            ).tr(),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  const String url = 'https://t.me/IlhomDev1';

                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  }
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: MyColors.ff2D3250,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  child: const Icon(
                    Icons.telegram,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uri url = Uri(scheme: 'tel', path: '+998901234567');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: MyColors.ff2D3250,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  child: const Icon(
                    Icons.phone_forwarded_rounded,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child) => Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).top,
                color: MyColors.ff7077A1.withOpacity(.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 2),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor:
                                  const Color.fromARGB(255, 180, 186, 216),
                              backgroundImage: AuthService.user.photoURL == null
                                  ? null
                                  : NetworkImage(value.myInfo!.image),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: MyColors.ff2D3250,
                                size: 55,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: FittedBox(
                            child: Text(
                              value.myInfo!.name,
                              style: TextStyle(
                                color: MyColors.ff2D3250,
                                fontSize: 8.5 *
                                    MediaQuery.devicePixelRatioOf(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: FittedBox(
                            child: Text(
                              value.myInfo!.email,
                              style: TextStyle(
                                color: MyColors.ff7077A1,
                                fontSize: 8.5 *
                                    MediaQuery.devicePixelRatioOf(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Card(
                      child: Container(
                        color: const Color.fromARGB(255, 180, 186, 216),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Category(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              icon: Icons.settings,
                              text: "Settings",
                              tf: true,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: MyColors.ff7077A1,
                            ),
                            Category(
                              onTap: () {
                                showNameEditDialog(context);
                              },
                              icon: Icons.edit_document,
                              text: "Data editing",
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: MyColors.ff7077A1,
                            ),
                            Category(
                              onTap: () {
                                showContactDialog(context);
                              },
                              icon: Icons.email,
                              text: "Contact us",
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: MyColors.ff7077A1,
                            ),
                            Category(
                              onTap: () async {
                                bool tf = await AuthService.signOut();
                                FirebaseFirestoreService.updateUserData(
                                    {'isOnline': false}, myUid);
                                if (tf == true) {
                                  if (mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage(),
                                      ),
                                    );
                                  }
                                } else {
                                  return;
                                }
                              },
                              icon: Icons.login,
                              text: "Sign out",
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.5,
                              color: MyColors.ff7077A1,
                            ),
                            Category(
                              onTap: () {
                                showWarningDialog(context);
                              },
                              icon: Icons.delete_rounded,
                              text: "Delete account",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
