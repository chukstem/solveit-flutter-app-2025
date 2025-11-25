import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/market.dart';
import 'package:solveit/features/market/domain/models/response/comments.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';

enum ProductTab { details, reviews }

class ProductDetailViewModel extends ChangeNotifier {
  ProductTab currentTab = ProductTab.details;
  int selectedImageIndex = 0;

  final CarouselSliderController carouselController = CarouselSliderController();

  void switchTab(ProductTab tab) {
    if (tab != currentTab) {
      currentTab = tab;
      notifyListeners();
    }
  }

  void selectImage(int index) {
    selectedImageIndex = index;
    carouselController.animateToPage(index, duration: const Duration(milliseconds: 300));
    notifyListeners();
  }

  void onCarouselChanged(int index, CarouselPageChangedReason reason) {
    selectedImageIndex = index;
    notifyListeners();
  }

  MarketProduct? currentProduct;

  setCurrentProduct(MarketProduct product) {
    currentProduct = product;
    if (kDebugMode) {
      log('Current product is $currentProduct\n');
      log('Reviews are :: ${marketViewModel.marketComments?.data.where((e) => e.marketProductId == currentProduct!.id).toList()}');
    }
  }

  List<String> get images => List.generate(6, (i) => 'https://picsum.photos/200/300');

  List<MarketComment> get reviews => marketViewModel.marketComments?.data.where((e) => e.marketProductId == currentProduct!.id).toList() ?? [];
}
