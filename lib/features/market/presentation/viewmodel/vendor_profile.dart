import 'package:flutter/material.dart';

class VendorViewModel extends ChangeNotifier {
  final String name = "Arlene McCoy";
  final String location = "Enugu";
  final String joinedDate = "28 March, 2024";

  final List<Map<String, String>> products = [
    {
      'title': 'Title of the product...',
      'price': '₦1,200',
      'location': 'Enugu',
      'image': 'https://picsum.photos/200'
    },
    {
      'title': 'Title of the product...',
      'price': '₦1,200',
      'location': 'Enugu',
      'image': 'https://picsum.photos/200'
    },
    {
      'title': 'Title of the product...',
      'price': '₦1,200',
      'location': 'Enugu',
      'image': 'https://picsum.photos/200'
    },
    {
      'title': 'Title of the product...',
      'price': '₦1,200',
      'location': 'Enugu',
      'image': 'https://picsum.photos/200'
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Arlene McCoy',
      'rating': 5,
      'text': 'Lorem ipsum dolor sit amet, consec nd fj jd sd sj dsjdjsdsds',
      'date': '2 days ago',
      'avatar': 'https://picsum.photos/200'
    },
    {
      'name': 'Arlene McCoy',
      'rating': 5,
      'text': 'Lorem ipsum dolor sit amet, consec nd fj jd sd sj dsjdjsdsds',
      'date': '2 days ago',
      'avatar': 'https://picsum.photos/200'
    },
  ];

  bool get hasProducts => products.isNotEmpty;
  bool get hasReviews => reviews.isNotEmpty;
}

class ReviewFilterViewModel extends ChangeNotifier {
  String selectedFilter = "All reviews";

  final filters = ["All reviews", "Marketplace", "Services"];

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
