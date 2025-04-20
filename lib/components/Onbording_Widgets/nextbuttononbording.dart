import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noproxys/Authantication/onbording_auth/onbording_auth.dart';
import 'package:noproxys/widgets/Themes/device_utls.dart';
import 'package:noproxys/widgets/Themes/size.dart';

class dotindicator extends StatelessWidget {
  const dotindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: Tsize.doubleSpacing,
      bottom: TDeviceUtils.getNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBordingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.blue,
        ),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
