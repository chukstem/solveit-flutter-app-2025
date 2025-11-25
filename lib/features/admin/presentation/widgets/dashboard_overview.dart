import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key, required this.adminViewModel});

  final AdminViewModel adminViewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, viewModel, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 20,
                  children: [
                    backButton(context),
                    Text(
                      'Dashboard Overview',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildStatsGrid(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer3<AdminViewModel, dynamic, dynamic>(
      builder: (context, adminViewModel, authModel, postsModel, _) {
        final users = authViewModel.allStudentsOrUserResponse;
        final posts = postsViewModel.allPostsResponse;
        final state = adminViewModel.state;
        final schools = state.schoolsResponse?.data;
        final departments = state.departmentsResponse?.data;
        final faculties = state.facultiesResponse?.data;
        final levels = state.levelsResponse?.data;

        return GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _StatCard(
              title: 'Total Users',
              value: users?.data.length.toString() ?? '0',
              icon: Icons.people_outline,
              color: Colors.blue,
            ),
            _StatCard(
              title: 'Active Posts',
              value: posts?.data?.length.toString() ?? '0',
              icon: Icons.article_outlined,
              color: Colors.green,
            ),
            _StatCard(
              title: 'Schools',
              value: (schools?.length ?? 0).toString(),
              icon: Icons.school_outlined,
              color: Colors.orange,
            ),
            _StatCard(
              title: 'Departments',
              value: departments?.length.toString() ?? '0',
              icon: Icons.category_outlined,
              color: Colors.purple,
            ),
            _StatCard(
              title: 'Faculties',
              value: faculties?.length.toString() ?? '0',
              icon: Icons.category_outlined,
              color: Colors.purple,
            ),
            _StatCard(
              title: 'Levels',
              value: levels?.length.toString() ?? '0',
              icon: Icons.class_outlined,
              color: Colors.teal,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
