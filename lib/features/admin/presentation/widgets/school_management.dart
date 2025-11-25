import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_department.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_faculty.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_level.dart';
import 'package:solveit/features/admin/data/models/requests/school/create_school.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/dropdown/app_dropdown.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class SchoolManagement extends StatelessWidget {
  const SchoolManagement({super.key, required this.adminViewModel});
  final AdminViewModel adminViewModel;

  void _showAddElementForm(BuildContext context, Widget formWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext bc) {
        // Provide the AdminViewModel to the form
        return ChangeNotifierProvider.value(
          value: context.read<AdminViewModel>(),
          child: formWidget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, viewModel, _) {
        final isDesktop = MediaQuery.of(context).size.width >= 600;
        final state = viewModel.state;

        return SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: isDesktop
                    ? _buildDesktopLayout(context, state)
                    : _buildMobileLayout(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'School Management',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          FilledButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.school_outlined),
                          title: const Text('School'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreateSchoolForm());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_balance_outlined),
                          title: const Text('Faculty'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreateFacultyForm());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business_outlined),
                          title: const Text('Department'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreateDepartmentForm());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.layers_outlined),
                          title: const Text('Level'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreateLevelForm());
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: Text(
              'Add School Element',
              style: context.bodySmall?.copyWith(color: Colors.white, fontSize: 8.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AdminState state) {
    return Row(
      children: [
        SizedBox(
          width: 250.w,
          child: _buildSchoolsList(state),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildSchoolDetails(state),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AdminState state) {
    return _buildSchoolsList(state);
  }

  Widget _buildSchoolsList(AdminState state) {
    final schools = state.schoolsResponse?.data;
    final departments = state.departmentsResponse?.data;
    final faculties = state.facultiesResponse?.data;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (schools == null || schools.isEmpty) {
      return const Center(child: Text('No schools found'));
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: schools.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final department = departments
                ?.where((department) => (department.schoolId == schools[index].id))
                .toList() ??
            [];
        final faculty =
            faculties?.where((faculties) => faculties.schoolId == schools[index].id).toList() ?? [];
        final school = schools[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.school),
            title: Text(school.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${faculty.length} Faculties'),
                Text('${department.length} Departments'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSchoolDetails(AdminState state) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School Details',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class CreateSchoolForm extends StatefulWidget {
  const CreateSchoolForm({super.key});

  @override
  State<CreateSchoolForm> createState() => _CreateSchoolFormState();
}

class _CreateSchoolFormState extends State<CreateSchoolForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      adminViewmodel.createSchoolRequest = CreateSchoolRequest(name: _nameController.text.trim());
      final success = await context.read<AdminViewModel>().createSchool();

      if (!mounted) return; // Check if widget is still in the tree

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('School created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Close the bottom sheet/dialog
        // Optionally: Refresh the schools list if needed
        context.read<AdminViewModel>().getSchools();
      } else {
        context.showError(
            'Failed to create school: ${context.read<AdminViewModel>().state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h, // Adjust for keyboard
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create New School", style: context.bodyLarge),
            SizedBox(height: 20.h),
            HTextField(
              controller: _nameController,
              title: "School Name",
              hint: "Enter school name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a school name';
                }
                return null;
              },
            ),
            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create School",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateFacultyForm extends StatefulWidget {
  const CreateFacultyForm({super.key});

  @override
  State<CreateFacultyForm> createState() => _CreateFacultyFormState();
}

class _CreateFacultyFormState extends State<CreateFacultyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedSchoolId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      adminViewmodel.createFacultyRequest = CreateFacultyRequest(
        name: _nameController.text.trim(),
        schoolId: _selectedSchoolId!,
      );
      final success = await context.read<AdminViewModel>().createFaculty();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Faculty created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
        context.read<AdminViewModel>().getFaculties(); // Refresh
      } else {
        context.showError(
            'Failed to create school: ${context.read<AdminViewModel>().state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.watch<AdminViewModel>();
    final schools = adminViewModel.state.schoolsResponse?.data ?? [];

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create New Faculty", style: context.bodyLarge),
            SizedBox(height: 20.h),
            // School Dropdown
            AppDropDownField(
              values: {for (var school in schools) school.id.toString(): school.name},
              hintText: "Select School",
              onChanged: (s) {
                setState(() {
                  _selectedSchoolId = s;
                });
              },
              selectedValue: _selectedSchoolId,
            ),
            SizedBox(height: 15.h),
            // Faculty Name
            HTextField(
              controller: _nameController,
              title: "Faculty Name",
              hint: "Enter faculty name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a faculty name';
                }
                return null;
              },
            ),
            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create Faculty",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateDepartmentForm extends StatefulWidget {
  const CreateDepartmentForm({super.key});

  @override
  State<CreateDepartmentForm> createState() => _CreateDepartmentFormState();
}

class _CreateDepartmentFormState extends State<CreateDepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedSchoolId;
  String? _selectedFacultyId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Faculty> _filteredFaculties = [];

  void _updateFilteredFaculties(String? schoolId, AdminViewModel viewModel) {
    if (schoolId == null) {
      _filteredFaculties = [];
    } else {
      final schoolIdInt = int.tryParse(schoolId);
      if (schoolIdInt != null) {
        _filteredFaculties = viewModel.state.facultiesResponse?.data
                .where((faculty) => faculty.schoolId == schoolIdInt)
                .toList() ??
            [];
      } else {
        _filteredFaculties = [];
      }
    }
    if (!_filteredFaculties.any((f) => f.id.toString() == _selectedFacultyId)) {
      _selectedFacultyId = null;
    }
    setState(() {});
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      adminViewmodel.createDepartmentRequest = CreateDepartmentRequest(
        name: _nameController.text.trim(),
        facultyId: _selectedFacultyId!,
        schoolId: _selectedSchoolId!,
      );
      final success = await context.read<AdminViewModel>().createDepartment();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Department created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
        context.read<AdminViewModel>().getDepartments(); // Refresh
      } else {
        context.showError(
            'Failed to create school: ${context.read<AdminViewModel>().state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.watch<AdminViewModel>();
    final schools = adminViewModel.state.schoolsResponse?.data ?? [];
    // Note: We use _filteredFaculties for the dropdown items

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create New Department", style: context.bodyLarge),
            SizedBox(height: 20.h),
            // School Dropdown
            AppDropDownField(
              values: {for (var school in schools) school.id.toString(): school.name},
              hintText: "Select School",
              onChanged: (s) {
                setState(() {
                  _selectedSchoolId = s;
                  _updateFilteredFaculties(s, adminViewModel);
                });
              },
              selectedValue: _selectedSchoolId,
            ),

            SizedBox(height: 15.h),
            // Faculty Dropdown (depends on selected school)
            AppDropDownField(
              values: {for (var faculty in _filteredFaculties) faculty.id.toString(): faculty.name},
              hintText: "Select Faculty",
              onChanged: (s) {
                setState(() {
                  _selectedFacultyId = s;
                });
              },
              selectedValue: _selectedFacultyId,
            ),

            if (_selectedSchoolId != null && _filteredFaculties.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'No faculties found for the selected school.',
                  style: TextStyle(color: Colors.orange[700], fontSize: 12.sp),
                ),
              ),
            SizedBox(height: 15.h),
            // Department Name
            HTextField(
              controller: _nameController,
              title: "Department Name",
              hint: "Enter department name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a department name';
                }
                return null;
              },
            ),
            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create Department",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateLevelForm extends StatefulWidget {
  const CreateLevelForm({super.key});

  @override
  State<CreateLevelForm> createState() => _CreateLevelFormState();
}

class _CreateLevelFormState extends State<CreateLevelForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedSchoolId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      adminViewmodel.createLevelRequest = CreateLevel(
        name: _nameController.text.trim(),
        schoolId: _selectedSchoolId!,
      );
      final success = await context.read<AdminViewModel>().createLevel();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        context.showSuccess('Level created successfully!');
        Navigator.pop(context);
      } else {
        context.showError(
            'Failed to create school: ${context.read<AdminViewModel>().state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.watch<AdminViewModel>();
    final schools = adminViewModel.state.schoolsResponse?.data ?? [];

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create New Level", style: context.bodyLarge),
            SizedBox(height: 20.h),
            // School Dropdown
            AppDropDownField(
              values: {for (var school in schools) school.id.toString(): school.name},
              hintText: "Select School",
              onChanged: (s) {
                setState(() {
                  _selectedSchoolId = s;
                });
              },
              selectedValue: _selectedSchoolId,
            ),
            SizedBox(height: 15.h),
            // Level Name
            HTextField(
              controller: _nameController,
              title: "Level Name",
              hint: "Enter level name (e.g., 100, 200)",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a level name';
                }
                return null;
              },
            ),
            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create Level",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
