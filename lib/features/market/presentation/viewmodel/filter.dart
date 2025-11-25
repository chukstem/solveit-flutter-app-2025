import 'package:flutter/material.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';

enum FilterTab { location, category, rating, price }

class MarketPlaceFilterViewModel extends ChangeNotifier {
  FilterTab selectedTab = FilterTab.location;

  List<String> selectedLocations = []; // Changed from List<int>
  List<int> selectedCategories = [];
  List<int> selectedRatings = [];
  RangeValues priceRange = const RangeValues(0, 100000); // Will be updated based on products

  List<MarketProduct> productsToFilter = [];
  List<MarketProduct> filteredProducts = [];

  Map<FilterTab, String> tabs = {FilterTab.location: 'Locations', FilterTab.category: 'Categories', FilterTab.rating: 'Ratings', FilterTab.price: 'Price'};

  void setListOfProductsToFilter(List<MarketProduct> products) {
    productsToFilter = products;

    notifyListeners();
  }

  void getPriceRangeToFilter(List<MarketProduct> products) {
    // Calculate price range based on actual product prices
    if (products.isNotEmpty) {
      double minPrice = double.maxFinite;
      double maxPrice = 0;

      for (var product in products) {
        final price = double.tryParse(product.amount) ?? 0;
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }

      // Add some padding to the range
      minPrice = (minPrice * 0.9).clamp(0, double.infinity);
      maxPrice = (maxPrice * 1.1).clamp(0, double.infinity);

      priceRange = RangeValues(minPrice, maxPrice);
    }

    notifyListeners();
  }

  void applyFilters() {
    filteredProducts = productsToFilter.where((product) {
      // Location filter now works with strings
      bool matchesLocation = selectedLocations.isEmpty || selectedLocations.contains(product.location);

      bool matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(product.marketProductTagId);

      bool matchesRating = selectedRatings.isEmpty; // Implement when rating field is available

      double productPrice = double.tryParse(product.amount) ?? 0;
      bool matchesPrice = productPrice >= priceRange.start && productPrice <= priceRange.end;

      return matchesLocation || matchesCategory || matchesRating || matchesPrice;
    }).toList();

    notifyListeners();
  }

  void switchTab(FilterTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void toggleLocation(String location) {
    // Changed from int to String
    if (selectedLocations.contains(location)) {
      selectedLocations.remove(location);
    } else {
      selectedLocations.add(location);
    }
    applyFilters();
  }

  void toggleCategory(int id) {
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
    } else {
      selectedCategories.add(id);
    }
    applyFilters();
  }

  void toggleRating(int stars) {
    if (selectedRatings.contains(stars)) {
      selectedRatings.remove(stars);
    } else {
      selectedRatings.add(stars);
    }
    applyFilters();
  }

  void updatePriceRange(RangeValues values) {
    priceRange = values;
    applyFilters();
  }

  void clearAll() {
    selectedLocations.clear();
    selectedCategories.clear();
    selectedRatings.clear();

    // Reset price range to the full range based on products
    if (productsToFilter.isNotEmpty) {
      double minPrice = double.maxFinite;
      double maxPrice = 0;

      for (var product in productsToFilter) {
        final price = double.tryParse(product.amount) ?? 0;
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }

      priceRange = RangeValues(minPrice, maxPrice);
    }

    filteredProducts = productsToFilter;
    notifyListeners();
  }

  int get matchedResults => filteredProducts.length;

  bool get hasSelections =>
      selectedLocations.isNotEmpty || selectedCategories.isNotEmpty || selectedRatings.isNotEmpty || priceRange != const RangeValues(0, 100000);

  List<String> get availableLocations => productsToFilter.map((p) => p.location).toSet().toList();
}
