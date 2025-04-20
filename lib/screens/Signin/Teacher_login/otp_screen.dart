import 'package:flutter/material.dart';
import 'package:noproxys/Authantication/firebase_auth/firebase_auth_method.dart';
import 'package:noproxys/widgets/Themes/buttons.dart';
import 'package:pinput/pinput.dart';

class OtpScreent extends StatefulWidget {
  const OtpScreent({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<OtpScreent> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreent> {
  String? otpCode; // ← Move this outside build()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade50,
                    ),
                    child: Image.asset("assets/images/loggg-rem.png"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verification",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Enter your OTP to verify your phone number",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),

                  // OTP Input Field
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onChanged: (value) {
                      otpCode = value; // ← Save the value to variable
                    },
                    onSubmitted: (value) {
                      AuthService().verifyOTP(
                        context,
                        value,
                        widget.verificationId,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // Verify Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButton(
                      text: "Verify",
                      onPressed: () {
                        if (otpCode != null && otpCode!.length == 6) {
                          AuthService().verifyOTP(
                            context,
                            otpCode!,
                            widget.verificationId,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter 6-digit OTP")),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Resend New Code",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
