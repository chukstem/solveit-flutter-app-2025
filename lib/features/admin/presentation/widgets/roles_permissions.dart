import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/viewmodel/role_permissions_viewmodel.dart';

class RolesAndPermissions extends StatelessWidget {
  const RolesAndPermissions({super.key, required this.adminViewModel});
  final AdminViewModel adminViewModel;

  @override
  Widget build(BuildContext context) {
    // We don't need to create a new instance here as we've already registered it with the DI container
    return const _RolesAndPermissionsContent();
  }
}

class _RolesAndPermissionsContent extends StatefulWidget {
  const _RolesAndPermissionsContent();

  @override
  State<_RolesAndPermissionsContent> createState() => _RolesAndPermissionsContentState();
}

class _RolesAndPermissionsContentState extends State<_RolesAndPermissionsContent> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final viewModel = context.read<RolePermissionsViewModel>();
    await viewModel.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final viewModel = context.watch<RolePermissionsViewModel>();
    final state = viewModel.state;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.errorMessage}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildHeader(context),
            TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.person_outline),
                  child: Text(
                    'Roles',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                Tab(
                  icon: const Icon(Icons.security),
                  child: Text(
                    'Permissions',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  isDesktop ? _buildDesktopRolesLayout() : _buildRolesList(),
                  _buildPermissionsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Text(
            'Roles & Permissions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create New'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRolesLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildRolesList(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: _buildRoleDetails(),
        ),
      ],
    );
  }

  Widget _buildRolesList() {
    final state = context.watch<RolePermissionsViewModel>().state;
    final roles = state.roles;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: roles.isEmpty ? 1 : roles.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          if (roles.isEmpty) {
            return const Center(
              child: Text('No roles found'),
            );
          }

          final role = roles[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(role.name),
              subtitle: Text('ID: ${role.id}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.read<RolePermissionsViewModel>().selectRole(role);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleDetails() {
    final state = context.watch<RolePermissionsViewModel>().state;
    final selectedRole = state.selectedRole;

    if (selectedRole == null) {
      return const Center(
        child: Text('No role selected'),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role: ${selectedRole.name}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'ID: ${selectedRole.id} | Slug: ${selectedRole.slug}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16.h),
          const Text('Assigned Permissions'),
          Expanded(
            child: state.permissions.isEmpty
                ? const Center(child: Text('No permissions available'))
                : ListView.builder(
                    itemCount: state.permissions.length,
                    itemBuilder: (context, index) {
                      final permission = state.permissions[index];
                      return CheckboxListTile(
                        title: Text(permission.name),
                        subtitle: Text(permission.slug),
                        value: false, // This would ideally be checked against role's permissions
                        onChanged: (value) {
                          context
                              .read<RolePermissionsViewModel>()
                              .togglePermission(permission.id.toString(), value ?? false);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsList() {
    final state = context.watch<RolePermissionsViewModel>().state;
    final permissions = state.permissions;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: permissions.isEmpty ? 1 : permissions.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          if (permissions.isEmpty) {
            return const Center(
              child: Text('No permissions found'),
            );
          }

          final permission = permissions[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.security),
              title: Text(permission.name),
              subtitle: Text(permission.slug),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
