import 'package:flutter/material.dart';

class ReportViewModel extends ChangeNotifier {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool _isVendor = false;
  bool get isVendor => _isVendor;

  void initialize({required bool vendor}) {
    _isVendor = vendor;
    notifyListeners();
  }

  bool get canSubmit =>
      subjectController.text.trim().isNotEmpty &&
      messageController.text.trim().isNotEmpty;

  void onChanged() => notifyListeners();

  void reset() {
    subjectController.clear();
    messageController.clear();
    _isVendor = false;
    notifyListeners();
  }
}
