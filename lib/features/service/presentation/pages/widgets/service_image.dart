import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/service/domain/response/get_core_services.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({super.key, required this.coreService});
  final CoreServiceModel coreService;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 70.h,
        child: Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                "https://picsum.photos/200/300",
                width: 80.w,
                fit: BoxFit.cover,
              ),
            ),

            // Product Info
            Expanded(
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    coreService.title,
                    style: context.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'NGN ${coreService.price}',
                    style: context.bodySmall?.copyWith(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 3.w,
                        children: [
                          AvatarWidget(
                            avatarUrl: 'https://picsum.photos/200/300',
                            radius: 10.sp,
                            isOnline: true,
                            hasRing: false,
                          ),
                          Text(coreService.id.toString(), style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(" 5 Stars ", style: context.bodySmall?.copyWith(color: Colors.orange)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
