import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.ff7077A1.withOpacity(.1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: MyColors.ff2D3250,
          ),
        ).tr(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: MyColors.ff2D3250,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.ff7077A1.withOpacity(.1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Application language",
                    style: TextStyle(
                        color: MyColors.ff2D3250,
                        fontSize: 8 * MediaQuery.devicePixelRatioOf(context),
                        fontWeight: FontWeight.w500),
                  ).tr(),
                  PopupMenuButton<Locale>(
                    onSelected: (value) {
                      log(value.toString());
                      context.setLocale(value);
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: Locale("uz", "UZ"),
                          child: Text("🇺🇿 UZ"),
                        ),
                        PopupMenuItem(
                          value: Locale("en", "US"),
                          child: Text("🇺🇸 EN"),
                        ),
                      ];
                    },
                    icon: const Icon(Icons.language_rounded),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
