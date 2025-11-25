import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/widgets/dashboard_content.dart';
import 'package:solveit/features/admin/presentation/widgets/dashboard_navigation.dart';
import 'package:solveit/utils/utils/getters.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load all required data sequentially
    await getAllSchoolElements(context);
    await authViewModel.getUsersOrStudents(false);
    postsViewModel.getAllPostsElements();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Consumer<AdminViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        return Scaffold(
          body: isDesktop
              ? _buildDesktopLayout(viewModel, state, Theme.of(context).colorScheme)
              : DashboardContent(section: state.selectedSection),
          bottomNavigationBar: isDesktop
              ? null
              : DashboardBottomNavigation(
                  selectedSection: state.selectedSection,
                  onSectionSelected: viewModel.selectSection,
                ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(AdminViewModel viewModel, AdminState state, ColorScheme colorScheme) {
    return Row(
      children: [
        DashboardNavigationRail(
          selectedSection: state.selectedSection,
          onSectionSelected: viewModel.selectSection,
          colorScheme: colorScheme,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: DashboardContent(section: state.selectedSection),
        ),
      ],
    );
  }
}
