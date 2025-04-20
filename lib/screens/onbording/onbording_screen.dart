import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noproxys/Authantication/onbording_auth/onbording_auth.dart';
import 'package:noproxys/components/Onbording_Widgets/dotsonbordingnav.dart';
import 'package:noproxys/components/Onbording_Widgets/nextbuttononbording.dart';
import 'package:noproxys/components/Onbording_Widgets/onbording_screens.dart';
import 'package:noproxys/components/Onbording_Widgets/skip_onbording.dart';
import 'package:noproxys/widgets/Themes/image_string.dart';
import 'package:noproxys/widgets/Themes/text_string.dart';

class OnBordingScreen extends StatelessWidget {
  const OnBordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBordingController());
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal scrolle page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePage,
            children: const [
              Onbording1(
                image: TImages.illustrator1,
                title: TText.onboardingTitle1,
                subtitle: TText.onboardingDescription1,
              ),
              Onbording1(
                image: TImages.illustrator2,
                title: TText.onboardingTitle2,
                subtitle: TText.onboardingDescription2,
              ),
              Onbording1(
                image: TImages.illustrator3,
                title: TText.onboardingTitle3,
                subtitle: TText.onboardingDescription3,
              ),
              // Skip button
            ],
          ),

          // skip button
          const skiponbording(),

          // Dot navigation smooth indecator
          const dotsonbordingnavigator(),
          //circular button
          const dotindicator(),
        ],
      ),
    );
  }
}
