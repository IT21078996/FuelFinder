import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/utils/image_constant.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage(ImageConstant.image1),
          width: 150,
        ),
        Positioned(
          child: Image(image: AssetImage(ImageConstant.image2), width: 300),
        ),
      ],
    );
  }
}
