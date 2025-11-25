import 'package:flutter/material.dart';

enum ServiceFilterType { location, category, rating }

class ServiceFilterViewModel extends ChangeNotifier {
  ServiceFilterType selectedTab = ServiceFilterType.location;

  List<int> selectedLocations = [];
  List<int> selectedCategories = [];
  List<int> selectedRatings = [];
  RangeValues priceRange = const RangeValues(20000, 95000);
  int matchedResults = 58;

  Map<ServiceFilterType, String> tabs = {
    ServiceFilterType.location: 'Locations',
    ServiceFilterType.category: 'Categories',
    ServiceFilterType.rating: 'Ratings',
  };

  void switchTab(ServiceFilterType tab) {
    clearAll();
    selectedTab = tab;
    notifyListeners();
  }

  void toggleLocation(int index) {
    if (selectedLocations.contains(index)) {
      selectedLocations.remove(index);
    } else {
      selectedLocations.add(index);
    }
    notifyListeners();
  }

  void toggleCategory(int index) {
    if (selectedCategories.contains(index)) {
      selectedCategories.remove(index);
    } else {
      selectedCategories.add(index);
    }
    notifyListeners();
  }

  void toggleRating(int stars) {
    if (selectedRatings.contains(stars)) {
      selectedRatings.remove(stars);
    } else {
      selectedRatings.add(stars);
    }
    notifyListeners();
  }

  void updatePriceRange(RangeValues values) {
    priceRange = values;
    notifyListeners();
  }

  void clearAll() {
    selectedLocations.clear();
    selectedCategories.clear();
    selectedRatings.clear();
    priceRange = const RangeValues(20000, 95000);
    notifyListeners();
  }

  bool get hasSelections =>
      selectedLocations.isNotEmpty ||
      selectedCategories.isNotEmpty ||
      selectedRatings.isNotEmpty;
}
