import 'package:flutter/material.dart';

enum SearchState {
  empty,
  recent,
  results,
}

class MarketSearchState {
  final List<String> recentSearches;
  final List<Map<String, String>> searchResults;
  final String searchQuery;

  const MarketSearchState({
    this.recentSearches = const [],
    this.searchResults = const [],
    this.searchQuery = '',
  });

  SearchState get state {
    final hasInput = searchQuery.isNotEmpty;
    if (!hasInput && recentSearches.isEmpty) return SearchState.empty;
    if (!hasInput && recentSearches.isNotEmpty) return SearchState.recent;
    return SearchState.results;
  }

  MarketSearchState copyWith({
    List<String>? recentSearches,
    List<Map<String, String>>? searchResults,
    String? searchQuery,
  }) {
    return MarketSearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  static const empty = MarketSearchState();
}

class MarketSearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  MarketSearchState _state = MarketSearchState.empty;
  MarketSearchState get state => _state;

  MarketSearchViewModel() {
    searchController.addListener(() {
      _setState(_state.copyWith(searchQuery: searchController.text));
      updateSearch(searchController.text);
    });
  }

  void _setState(MarketSearchState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  List<String> get recentSearches => _state.recentSearches;
  List<Map<String, String>> get searchResults => _state.searchResults;
  SearchState get searchState => _state.state;

  void updateSearch(String value) {
    if (value.isNotEmpty) {
      final results = _mockSearch(value, value.trim().length);
      _setState(_state.copyWith(searchResults: results));
    } else {
      _setState(_state.copyWith(searchResults: []));
    }
  }

  void submitSearch(String value) {
    if (value.trim().isEmpty) return;

    // Add to recent searches if not already there
    List<String> updatedSearches = List.from(_state.recentSearches);
    if (!updatedSearches.contains(value)) {
      updatedSearches.insert(0, value);
    }

    searchController.text = value;

    final results = _mockSearch(value, value.trim().length);
    _setState(_state.copyWith(
      recentSearches: updatedSearches,
      searchResults: results,
      searchQuery: value,
    ));
  }

  void clearSearch() {
    searchController.clear();
    _setState(_state.copyWith(
      searchResults: [],
      searchQuery: '',
    ));
  }

  List<Map<String, String>> _mockSearch(String query, int length) {
    return List.generate(length > 10 ? 0 : 10 - length, (index) {
      return {
        "title": "Related product name",
        "subtitle": "Category name",
        "image": "https://picsum.photos/200/300"
      };
    });
  }
}
