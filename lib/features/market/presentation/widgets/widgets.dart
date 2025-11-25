import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/market/domain/models/response/market_product.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/utils.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        height: 30.h,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 0.1, color: selected ? context.backgroundColor : context.primaryColor),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(selected ? context.primaryColor : Colors.white),
            ),
            child: Text(label, textAlign: TextAlign.center, style: context.bodySmall?.copyWith(color: selected ? Colors.white : Colors.black))),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final MarketProduct product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                isImage(product.images) ? product.images : "https://picsum.photos/200/300",
                width: double.infinity,
                // Change BoxFit to fillWidth
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  "https://picsum.photos/200/300",
                  // Also apply fit here for consistency in error case
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.amount,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
                Text(
                  product.title,
                  style: context.bodyMedium?.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.location,
                  style: context.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
