import 'package:flutter/material.dart';
import 'package:noproxys/widgets/Themes/helper.dart';
import 'package:noproxys/widgets/Themes/size.dart';

class Onbording1 extends StatelessWidget {
  const Onbording1({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // SizedBox(
          //   width: THelperFunction.screenWidth() * 0.8,
          //   height: THelperFunction.screenHeight() * 0.6,
          //   child: Image.asset(
          //     "assets/images/illu2.jpg",
          //   )),
          Image(
            width: THelperFunction.screenWidth() * 0.8,
            height: THelperFunction.screenHeight() * 0.6,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Tsize.spaceBtwItems),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
