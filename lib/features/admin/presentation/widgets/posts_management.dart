import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/admin/data/models/requests/posts/create_category.dart';
import 'package:solveit/features/admin/data/models/requests/posts/create_post.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/posts_viewmodel.dart';
import 'package:solveit/features/school/data/models/responses/get_departments.dart';
import 'package:solveit/features/school/data/models/responses/get_faculties.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/dropdown/app_dropdown.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class PostsManagement extends StatelessWidget {
  const PostsManagement({super.key, required this.adminViewModel});
  final AdminViewModel adminViewModel;

  // Helper function to show forms in a modal bottom sheet
  void _showAddElementForm(BuildContext context, Widget formWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext bc) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: context.read<AdminViewModel>()),
            ChangeNotifierProvider.value(value: context.read<PostsViewmodel>()),
          ],
          child: formWidget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Posts Management',
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
                          leading: const Icon(Icons.article_outlined),
                          title: const Text('Post'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreatePostForm());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.category_outlined),
                          title: const Text('Category'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAddElementForm(context, const CreateCategoryForm());
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
              'Add Post Element',
              style: context.bodySmall?.copyWith(color: Colors.white, fontSize: 8.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildPostsList(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: _buildCategoriesList(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.article),
                child: Text(
                  'Posts',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              Tab(
                icon: const Icon(Icons.category),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPostsList(),
                _buildCategoriesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList() {
    final posts = postsViewModel.allPostsResponse;
    final categories = postsViewModel.allCategoriesResponse;

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: posts?.data?.length ?? 0,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final post = posts?.data?[index];
        final categoryName =
            categories?.data?.firstWhere((e) => e.id == post?.newsCategoryId).name ?? '';
        return Card(
          child: ListTile(
            leading: const Icon(Icons.article),
            title: Text('Post Title: ${post?.title ?? ''}', style: context.bodySmall?.copyWith()),
            subtitle: Text('Category: $categoryName', style: context.bodySmall?.copyWith()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList() {
    final posts = postsViewModel.allPostsResponse;
    final categories = postsViewModel.allCategoriesResponse;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            itemCount: categories?.data?.length ?? 0,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final category = categories?.data?[index];
              final postCount =
                  posts?.data?.where((post) => post.newsCategoryId == category?.id).length ?? 0;
              return Card(
                child: ListTile(
                  title: Text('${category?.name}', style: context.bodySmall?.copyWith()),
                  subtitle: Text('$postCount Posts', style: context.bodySmall?.copyWith()),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CreateCategoryForm extends StatefulWidget {
  const CreateCategoryForm({super.key});

  @override
  State<CreateCategoryForm> createState() => _CreateCategoryFormState();
}

class _CreateCategoryFormState extends State<CreateCategoryForm> {
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

      adminViewmodel.createCategoryRequest = CategoryRequest(
        name: _nameController.text.trim(),
        schoolId: _selectedSchoolId!,
      );

      final success = await context.read<AdminViewModel>().createCategory();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        context.showSuccess('Category created successfully!');
        context.read<PostsViewmodel>().getAllPostsElements();
        Navigator.pop(context);
      } else {
        context.showError(
            'Failed to create category: ${context.read<AdminViewModel>().state.errorMessage}');
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
            Text("Create New Category", style: context.bodyLarge),
            SizedBox(height: 20.h),

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
            // Category Name
            HTextField(
              controller: _nameController,
              title: "Category Name",
              hint: "Enter category name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create Category",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _bodyController = TextEditingController();
  final _mediaController = TextEditingController();
  final _tagsController = TextEditingController();
  final _facultiesController = TextEditingController();
  final _departmentsController = TextEditingController();

  String? _selectedSchoolId;
  String? _selectedCategoryId;
  bool _isLoading = false;
  File? file;
  String? _selectedFacultyId;
  String? _selectedDepartmentId;

  List<Faculty> _filteredFaculties = [];
  List<Department> _filteredDepartments = [];

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

  void _updateFilteredDepartments(String? schoolId, int facultyId, AdminViewModel viewModel) {
    if (schoolId == null) {
      _filteredDepartments = [];
    } else {
      final schoolIdInt = int.tryParse(schoolId);
      if (schoolIdInt != null) {
        _filteredDepartments = viewModel.state.departmentsResponse?.data
                .where((dep) => (dep.schoolId == schoolIdInt && dep.facultyId == facultyId))
                .toList() ??
            [];
      } else {
        _filteredDepartments = [];
      }
    }
    if (!_filteredDepartments.any((f) => f.id.toString() == _selectedDepartmentId)) {
      _selectedDepartmentId = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _bodyController.dispose();
    _mediaController.dispose();
    _tagsController.dispose();
    _facultiesController.dispose();
    _departmentsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? true) {
      setState(() {
        _isLoading = true;
      });

      // Safely parse IDs
      final schoolIdInt = int.tryParse(_selectedSchoolId ?? '');
      final categoryIdInt = int.tryParse(_selectedCategoryId ?? '');

      if (schoolIdInt == null || categoryIdInt == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid School or Category ID.'), backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      adminViewmodel.createPostRequest = PostRequest(
        userId: userStateManager.state.token.user?.id ?? 1,
        schoolId: schoolIdInt,
        newsCategoryId: categoryIdInt,
        title: _titleController.text.trim(),
        excerpt: _excerptController.text.trim(),
        body: _bodyController.text.trim(),
        tags: _tagsController.text.trim(),
        faculties: _facultiesController.text.trim(),
        departments: _selectedDepartmentId,
      );

      // Assuming you have a method like createPost in AdminViewModel
      final success = await context.read<AdminViewModel>().createPost();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        context.showSuccess('Post created successfully!');
        context.read<PostsViewmodel>().getAllPostsElements();
        Navigator.pop(context);
      } else {
        context.showError(
            'Failed to create post: ${context.read<AdminViewModel>().state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.watch<AdminViewModel>();
    final schools = adminViewModel.state.schoolsResponse?.data ?? [];
    final categories = postsViewModel.allCategoriesResponse?.data ?? [];

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create New Post", style: context.bodyLarge),
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
            AppDropDownField(
              values: {for (var cat in categories) cat.id.toString(): cat.name},
              hintText: "Select Category",
              onChanged: (s) {
                setState(() {
                  _selectedCategoryId = s;
                });
              },
              selectedValue: _selectedCategoryId,
            ),
            SizedBox(height: 15.h),

            // Post Title
            HTextField(
              controller: _titleController,
              title: "Post Title",
              hint: "Enter post title",
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Title is required' : null,
            ),
            SizedBox(height: 15.h),

            // Post Excerpt
            HTextField(
              controller: _excerptController,
              title: "Excerpt (Short Summary)",
              hint: "Enter a brief summary",
              maxLength: 100,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Excerpt is required' : null,
            ),
            SizedBox(height: 15.h),

            // Post Body
            HTextField(
              controller: _bodyController,
              title: "Body (Full Content)",
              hint: "Enter the full post content",
              maxLength: 500,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Body is required' : null,
            ),
            SizedBox(height: 15.h),

            // Media URL/Path

            // Tags
            HTextField(
              controller: _tagsController,
              title: "Tags",
              hint: "Comma-separated tags (e.g., news,events)",
            ),
            SizedBox(height: 15.h),
            AppDropDownField(
              values: {for (var faculty in _filteredFaculties) faculty.id.toString(): faculty.name},
              hintText: "Select Faculty",
              onChanged: (s) {
                if (s != null) {
                  setState(() {
                    _selectedFacultyId = s;
                    _updateFilteredDepartments(
                        _selectedSchoolId, int.tryParse(s) ?? 0, adminViewModel);
                  });
                }
              },
              selectedValue: _selectedFacultyId,
            ),

            SizedBox(height: 15.h),
            AppDropDownField(
              values: {for (var dep in _filteredDepartments) dep.id.toString(): dep.name},
              hintText: "Select Departments",
              onChanged: (s) {
                if (s != null) {
                  setState(() {
                    _selectedDepartmentId = s;
                  });
                }
              },
              selectedValue: _selectedDepartmentId,
            ),
            SizedBox(height: 15.h),

            HTextField(
              controller: _facultiesController,
              title: "Faculties",
              hint: "Enter Faculties",
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Faculty is required' : null,
            ),
            SizedBox(height: 15.h),
            HTextField(
              controller: _departmentsController,
              title: "Departments",
              hint: "Enter Departments, seperated by a comma",
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Departments is required' : null,
            ),

            SizedBox(height: 25.h),
            HFilledButton(
              text: "Create Post",
              onPressed: _submitForm,
              loading: _isLoading,
            ),
            SizedBox(height: 10.h), // Extra space at bottom
          ],
        ),
      ),
    );
  }
}
