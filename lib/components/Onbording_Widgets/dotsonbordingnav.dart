import 'package:flutter/material.dart';
import 'package:noproxys/Authantication/onbording_auth/onbording_auth.dart';
import 'package:noproxys/widgets/Themes/color.dart';
import 'package:noproxys/widgets/Themes/device_utls.dart';
import 'package:noproxys/widgets/Themes/size.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class dotsonbordingnavigator extends StatelessWidget {
  const dotsonbordingnavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBordingController.instance;
    return Positioned(
      bottom: TDeviceUtils.getNavigationBarHeight() + 25,
      left: Tsize.doubleSpacing,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 3,
        effect: const ExpandingDotsEffect(
          activeDotColor: TColors.primaryColor,
          dotHeight: 6,
        ),
      ),
    );
  }
}
