import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';
import 'package:solveit/features/service/presentation/viewmodels/core_services_viewmodel.dart';
import 'package:solveit/features/service/presentation/viewmodels/services_viewmodel.dart';

class ServiceCategories extends StatelessWidget {
  final ServicesViewModel viewModel;
  final CoreServicesViewModel coreViewModel;

  const ServiceCategories({
    super.key,
    required this.viewModel,
    required this.coreViewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (coreViewModel.categoriesResponse == null) {
      return const SizedBox();
    }

    final categories = coreViewModel.categoriesResponse!.data;
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map(
                (cat) => CategoryChip(
                  label: cat.name,
                  selected: viewModel.selectedCategory == cat.name.toLowerCase(),
                  onPressed: () => viewModel.selectCategory(cat.name),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
