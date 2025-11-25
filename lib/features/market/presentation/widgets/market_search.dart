import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(searchIcon),
            Text("No recent searches", style: context.bodyLarge!.copyWith()),
            Text("Your recent searches would be display here", style: context.bodySmall!.copyWith())
          ],
        ),
      ),
    );
  }
}

class SearchRecentList extends StatelessWidget {
  final List<String> recent;
  final Function(String) onTap;

  const SearchRecentList({super.key, required this.recent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recent.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.history, color: Colors.grey),
        title: Text(recent[index], style: context.bodySmall),
        onTap: () {
          onTap(recent[index]);
        },
      ),
    );
  }
}

class SearchResultsList extends StatelessWidget {
  final List<Map<String, String>> results;
  final VoidCallback? onTap;

  const SearchResultsList({super.key, required this.results, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return SizedBox(
          height: 50.h,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6.sp),
              child: Image.network(item["image"]!, width: 30.h, height: 30.h, fit: BoxFit.cover),
            ),
            title: Text(item["title"]!, style: context.bodySmall),
            subtitle: Text(item["subtitle"]!,
                style: context.bodySmall!.copyWith(
                  color: Colors.grey,
                )),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
