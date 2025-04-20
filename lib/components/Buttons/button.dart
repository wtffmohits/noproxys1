import 'package:flutter/material.dart';
import 'package:noproxys/widgets/Themes/color.dart';

class BlueButton extends StatelessWidget {
  final String lable;
  final Function()? onTap;

  final VoidCallback? onPressed;

  const BlueButton({
    super.key,
    required this.lable,
    this.onPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColors.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          lable,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
