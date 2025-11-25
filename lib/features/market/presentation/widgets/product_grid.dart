import 'package:flutter/material.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';

class ProductGrid extends StatelessWidget {
  final List<MarketProduct> products;
  final Function(MarketProduct) onProductTap;
  final String? errorMessage;
  final bool isLoading;
  final ScrollController? scrollController;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.errorMessage,
    this.isLoading = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return SliverFillRemaining(
        child: Center(
          child: Text(errorMessage!),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];

            return GestureDetector(
              onTap: () => onProductTap(product),
              child: ProductCard(product: product),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
