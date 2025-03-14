import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpDialogContent extends StatefulWidget {
  const OtpDialogContent({
    super.key,
    required this.formKey,
    required this.fields,
    required this.signupEmail,
    required this.signupPass,
  });

  final GlobalKey<FormState> formKey;
  final int? fields;
  final String signupEmail;
  final String signupPass;

  @override
  State<OtpDialogContent> createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<OtpDialogContent> {
  bool isBusy = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Stack(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "EMAIL VERIFICATION OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                OtpTextField(
                  autoFocus: true,
                  showFieldAsBox: true,
                  numberOfFields: widget.fields ?? 4,
                  keyboardType: TextInputType.text,
                  borderColor: const Color(0xFF6A53A1),
                  focusedBorderColor: const Color(0xFF6A53A1),
                  disabledBorderColor: const Color(0xFF6A53A1),
                  enabledBorderColor: const Color(0xFF6A53A1),
                  onSubmit: (value) {
                    setState(() {
                      isBusy = true;
                    });
                    // widget.model.verifyCode(
                    //   context,
                    //   widget.signupEmail.trim(),
                    //   widget.signupPass.trim(),
                    //   value,
                    //   () {
                    //     setState(() {
                    //       isBusy = false;
                    //     });
                    //   },
                    // );
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  "Input the OTP send to \"${widget.signupEmail}\"",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text(
                    "Check your email spam folder if the OTP can't be found in your default inbox.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CloseButton(
                      color: Colors.black38,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          isBusy
              ? const SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
