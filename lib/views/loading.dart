import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: MyColors.ff424769.withOpacity(.45),
      child: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: MyColors.ffF6B17A,
          size: 50,
        ),
      ),
    );
  }
}
