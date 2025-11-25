import 'package:flutter/material.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_search.dart';

class ServiceSearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  ServiceSearchViewModel() {
    searchController.addListener(() {
      searchController.addListener(() {
        notifyListeners();
      });
    });
  }

  List<String> recentSearches = [];
  List<Map<String, String>> searchResults = [];

  SearchState get state {
    final hasInput = searchController.text.isNotEmpty;
    if (!hasInput && recentSearches.isEmpty) return SearchState.empty;
    if (!hasInput && recentSearches.isNotEmpty) return SearchState.recent;

    return SearchState.results;
  }

  void updateSearch(String value) {
    if (value.isNotEmpty) {
      searchResults = _mockSearch(value, value.trim().length);
    } else {
      searchResults.clear();
    }
    notifyListeners();
  }

  void submitSearch(String value) {
    if (value.trim().isEmpty) return;
    if (!recentSearches.contains(value)) {
      recentSearches.insert(0, value);
    }
    searchController.text = value;
    updateSearch(value);
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    notifyListeners();
  }

  List<Map<String, String>> _mockSearch(String query, int length) {
    return List.generate(length > 10 ? 0 : 10 - length, (index) {
      return {
        "title": "Laundry Service",
        "subtitle": "High-quality service provider",
        "image": "https://picsum.photos/$index/300"
      };
    });
  }
}
