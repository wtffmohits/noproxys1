import 'package:flutter/material.dart';
import 'package:noproxys/Authantication/firebase_auth/firebase_auth_method.dart';
import 'package:noproxys/widgets/Themes/buttons.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthService _authService = AuthService();
  String? otpCode;
  bool _isLoading = false;

  void handleVerifyOtp() {
    if (otpCode != null && otpCode!.length == 6) {
      setState(() {
        _isLoading = true;
      });
      _authService.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        smsCode: otpCode!,
      );
      // Only set loading to false if verification fails (handled in AuthService)
      // On success, it will navigate away.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6-digit OTP")));
    }
  }

  void handleResendOtp() {
    _authService.sendOtp(context: context, phoneNumber: widget.phoneNumber);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("A new OTP has been sent.")));
  }

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
                      otpCode = value;
                    },
                    // ** FIX: onSubmitted now calls the correct handler **
                    onSubmitted: (value) {
                      handleVerifyOtp();
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButton(
                      text: _isLoading ? "Verifying..." : "Verify",
                      onPressed: () {
                        if (!_isLoading) handleVerifyOtp();
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // <-- Added missing SizedBox
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextButton(
                    onPressed: handleResendOtp,
                    child: const Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
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
// This code is a Flutter widget for an OTP verification screen. It allows users to enter a 6-digit OTP sent to their phone number and verify it using Firebase authentication. The UI includes a circular image, a title, instructions, an input field for the OTP, and buttons for verification and resending the OTP. The widget handles loading states and provides feedback to the user.