import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';
import 'package:solveit/utils/extensions.dart';

class AccountVerificationOtpSheet extends StatefulWidget {
  const AccountVerificationOtpSheet({super.key}) : super();

  @override
  State<AccountVerificationOtpSheet> createState() {
    return _AccountVerificationOtpSheetState();
  }
}

class _AccountVerificationOtpSheetState extends State<AccountVerificationOtpSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final defaultPinTheme = PinTheme(
    width: context.getSize().width / 6,
    height: context.getSize().width / 6,
    textStyle: context.titleLarge,
    decoration: BoxDecoration(
      border: Border.all(color: context.colorScheme.surface, width: 1.w),
      borderRadius: BorderRadius.circular(defCornerRadius),
    ),
  );

  late final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: context.primaryColor),
  );

  late final submittedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: context.primaryColor),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding.copyWith(top: 20.h, bottom: 20.h),
      child: HScollableColumn(
        wrap: true,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.getLocalization()!.account_verification, style: context.titleMedium, textAlign: TextAlign.center),
          SizedBox(
            height: 10.h,
          ),
          Text(
            context.getLocalization()!.check_your_sms_we_sent_a_varification("09093284414", "sms", context.getLocalization()!.phone_number),
            style: context.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40.h,
          ),
          Pinput(
            defaultPinTheme: defaultPinTheme,
            length: 4,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: (s) {
              return "";
            },
            errorText: null,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            preFilledWidget: Text(
              "0",
              style: context.titleLarge?.copyWith(color: context.surfaceOnBackground.withValues(alpha: (0.5))),
            ),
            errorTextStyle: Theme.of(context).textTheme.bodyMedium,
            onCompleted: (s) {},
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
          ),
          SizedBox(
            height: 40.h,
          ),
          Text(context.getLocalization()!.didnt_received_otp, style: context.bodySmall?.copyWith(fontSize: 12.sp)),
          SizedBox(
            height: 14.h,
          ),
          Stack(children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: context.colorScheme.surface, shape: BoxShape.circle),
              ),
            ),
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: Transform.flip(
                flipX: true,
                child: CircularProgressIndicator(
                  backgroundColor: context.colorScheme.surface,
                  color: context.primaryColor,
                  value: 0.7,
                  strokeWidth: 5.w,
                ),
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "36",
                    style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ))
          ]),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class VerificationOtpSheet extends StatefulWidget {
  final String title;
  final String phoneNumber;
  final String channel;
  final DateTime? otpSentTime;
  final bool loading;
  final Function(String) onOtpEntered;
  final Function() resendOtp;

  const VerificationOtpSheet(
      {super.key,
      required this.title,
      required this.phoneNumber,
      this.otpSentTime,
      this.channel = "sms",
      this.loading = false,
      required this.resendOtp,
      required this.onOtpEntered})
      : super();

  @override
  State<VerificationOtpSheet> createState() {
    return _VerificationOtpSheetState();
  }
}

class _VerificationOtpSheetState extends State<VerificationOtpSheet> {
  int _difference = 0; // Initialize the difference to 0
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(VerificationOtpSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.otpSentTime != widget.otpSentTime) {
      _startTimer();
    }
  }

  void _startTimer() {
    final difference = widget.otpSentTime != null ? 60 - DateTime.now().difference(widget.otpSentTime!).inSeconds : 0;
    debugPrint(difference.toString());
    setState(() {
      _difference = difference;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Recalculate the difference every second
        _difference = widget.otpSentTime != null ? 60 - DateTime.now().difference(widget.otpSentTime!).inSeconds : 0;

        if (_difference <= 0) {
          // Stop the timer once the countdown is over
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  late final defaultPinTheme = PinTheme(
    width: context.getSize().width / 6,
    height: context.getSize().width / 6,
    textStyle: context.titleLarge,
    decoration: BoxDecoration(
      border: Border.all(color: context.colorScheme.surface, width: 1.w),
      borderRadius: BorderRadius.circular(defCornerRadius),
    ),
  );

  late final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: context.primaryColor),
  );

  late final submittedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: context.primaryColor),
  );
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final difference = widget.otpSentTime != null ? 60 - DateTime.now().difference(widget.otpSentTime!).inSeconds : 0;
    return Padding(
        padding: horizontalPadding.copyWith(top: 20.h, bottom: 20.h),
        child: HScollableColumn(wrap: true, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(widget.title, style: context.titleMedium, textAlign: TextAlign.center),
          SizedBox(
            height: 10.h,
          ),
          Text(
            context.getLocalization()!.check_your_sms_we_sent_a_varification(widget.phoneNumber, widget.channel,
                widget.channel == "sms" ? context.getLocalization()!.phone_number : context.getLocalization()!.email_address),
            style: context.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40.h,
          ),
          Pinput(
            defaultPinTheme: defaultPinTheme,
            length: 5,
            enabled: !widget.loading,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: (s) {
              return "";
            },
            errorText: null,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            preFilledWidget: Text(
              "0",
              style: context.titleLarge?.copyWith(color: context.surfaceOnBackground.withValues(alpha: (0.5))),
            ),
            errorTextStyle: Theme.of(context).textTheme.bodyMedium,
            onCompleted: (s) {
              widget.onOtpEntered(s);
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
          ),
          SizedBox(
            height: 5.h,
          ),
          if (widget.loading)
            LinearProgressIndicator(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(14.w),
            ),
          SizedBox(
            height: 35.h,
          ),
          Text(context.getLocalization()!.didnt_received_otp, style: context.bodySmall?.copyWith(fontSize: 12.sp)),
          SizedBox(
            height: 14.h,
          ),
          if (widget.otpSentTime != null && difference > 0) ...[
            Stack(children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(color: context.colorScheme.surface, shape: BoxShape.circle),
                ),
              ),
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: Transform.flip(
                  flipX: true,
                  child: CircularProgressIndicator(
                    backgroundColor: context.colorScheme.surface,
                    color: context.primaryColor,
                    value: difference.toDouble() / 60,
                    strokeWidth: 5.w,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      _difference.toString(),
                      style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ))
            ]),
            SizedBox(
              height: 20.h,
            ),
          ],
          if (difference <= 0) ...[
            InkWell(
                onTap: () => widget.resendOtp(),
                child: Text(
                  context.getLocalization()!.resend_otp,
                  style: context.headlineMedium?.copyWith(color: context.primaryColor),
                ))
          ]
        ]));
  }
}
