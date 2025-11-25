// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';

/// **OTP Verification State Model**
class OtpVerificationState {
  final List<String> otpValues;
  final bool isError;
  final String errorMessage;
  final int remainingTime;
  final bool isVerified;

  const OtpVerificationState({
    this.otpValues = const ['', '', '', '', '', ''],
    this.isError = false,
    this.errorMessage = '',
    this.remainingTime = 60,
    this.isVerified = false,
  });

  String get otpCode => otpValues.join();
  bool get isComplete => otpValues.every((value) => value.isNotEmpty);
  bool get canResend => remainingTime <= 0;

  OtpVerificationState copyWith({
    List<String>? otpValues,
    bool? isError,
    String? errorMessage,
    int? remainingTime,
    bool? isVerified,
  }) {
    return OtpVerificationState(
      otpValues: otpValues ?? this.otpValues,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      remainingTime: remainingTime ?? this.remainingTime,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  OtpVerificationState updateOtpDigit(int index, String value) {
    if (index < 0 || index >= otpValues.length) return this;

    final updatedValues = List<String>.from(otpValues);
    updatedValues[index] = value;

    return copyWith(otpValues: updatedValues);
  }
}

/// **OtpVerificationViewModel for OTP Verification Process**
class OtpVerificationViewModel extends ChangeNotifier {
  // Internal state
  OtpVerificationState _state = const OtpVerificationState();
  OtpVerificationState get state => _state;

  // Controllers for input fields
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  // Timer for countdown
  Timer? _timer;

  OtpVerificationViewModel() {
    _startTimer();
  }

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    List<String>? otpValues,
    bool? isError,
    String? errorMessage,
    int? remainingTime,
    bool? isVerified,
  }) {
    _state = _state.copyWith(
      otpValues: otpValues,
      isError: isError,
      errorMessage: errorMessage,
      remainingTime: remainingTime,
      isVerified: isVerified,
    );
    notifyListeners();
  }

  void updateUi() => notifyListeners();

  /// ✅ **Starts the countdown timer**
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.remainingTime > 0) {
        _setState(remainingTime: _state.remainingTime - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  /// ✅ **Handles OTP input changes and focus management**
  void onOtpChanged(String value, int index, BuildContext context) {
    // Update the state with the new digit
    final newState = _state.updateOtpDigit(index, value);
    _setState(otpValues: newState.otpValues);

    // Sync with controller
    otpControllers[index].text = value;

    // Handle focus
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
        verifyOtp();
      }
    }
  }

  /// ✅ **Validates the complete OTP code**
  void verifyOtp() {
    // OTP verification is now handled in the UI layer which calls the API
    // This method is kept for backward compatibility but does nothing
    // The actual verification happens in verify_email.dart screen
  }

  /// ✅ **Handles code resend request**
  Future<void> resendCode() async {
    // Resend code will be handled in the UI layer
    _setState(
      remainingTime: 60,
      isError: false,
      errorMessage: "",
    );
    _startTimer();
  }

  /// ✅ **Clears all input values**
  void clearValues() {
    _setState(
      remainingTime: 0,
      otpValues: List.filled(6, ''),
    );

    for (var controller in otpControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
