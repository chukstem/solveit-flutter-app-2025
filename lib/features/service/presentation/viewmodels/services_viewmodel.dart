import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:solveit/core/injections/services.dart';
import 'package:solveit/features/service/domain/response/get_core_services.dart';

class ServicesViewModel extends ChangeNotifier {
  ServicesViewModel() {
    coreServicesViewModel.getAllCoreServicesElements();
    scrollController.addListener(_scrollListener);
  }
  bool _isScrolling = false;
  final ScrollController scrollController = ScrollController();

  String selectedCategory = 'all';

  bool get isScrolling => _isScrolling;

  CoreServiceModel? currentCoreService;

  setCurrentCoreService(CoreServiceModel coreService) {
    currentCoreService = coreService;
    notifyListeners();
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrolling) {
        _isScrolling = true;
        notifyListeners();
      }
    } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (_isScrolling) {
        _isScrolling = false;
        notifyListeners();
      }
    }
  }

  void selectCategory(String category) {
    selectedCategory = category.toLowerCase();
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
