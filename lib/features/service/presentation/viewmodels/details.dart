import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:solveit/features/market/presentation/viewmodel/details.dart';

class ServicesDetailViewModel extends ChangeNotifier {
  ProductTab currentTab = ProductTab.details;
  int selectedImageIndex = 0;

  final CarouselSliderController carouselController =
      CarouselSliderController();

  void switchTab(ProductTab tab) {
    if (tab != currentTab) {
      currentTab = tab;
      notifyListeners();
    }
  }

  void selectImage(int index) {
    selectedImageIndex = index;
    carouselController.animateToPage(index,
        duration: const Duration(milliseconds: 300));
    notifyListeners();
  }

  void onCarouselChanged(int index, CarouselPageChangedReason reason) {
    selectedImageIndex = index;
    notifyListeners();
  }

  List<String> get images =>
      List.generate(6, (i) => 'https://picsum.photos/${i * 30}/300');

  List<Map<String, String>> get reviews => List.generate(5, (index) {
        return {
          'name': 'Arlene McCoy',
          'comment': 'Lorem ipsum dolor sit amet, consec',
          'date': '2 days ago',
          'avatar': 'https://picsum.photos/${index * 20}'
        };
      });
}
