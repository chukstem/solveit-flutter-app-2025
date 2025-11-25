// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/features/school/presentation/school_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';
import 'package:solveit/utils/theme/widgets/loaders.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';
import 'package:solveit/utils/utils/utils.dart';

extension on String {
  bool isStudent() {
    return toLowerCase() == ('student');
  }

  bool isStaff() {
    return toLowerCase() == ('staff');
  }

  bool isLecturer() {
    return toLowerCase() == ('lecturer');
  }
}

class InstitutionRegistrationScreen extends StatelessWidget {
  final String type;
  const InstitutionRegistrationScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final schoolViewModel = context.watch<SchoolViewModel>(); // ✅ Fixed typo
    return Consumer<RegistrationViewModel>(builder: (context, viewmodel, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 45.w,
          leading: backButton(
            context,
            onTap: () {
              context.pop();
              context.read<RegistrationViewModel>().clearFields();
            },
          ),
        ),
        bottomNavigationBar: Padding(
            padding: horizontalPadding.copyWith(bottom: context.getBottomPadding() + 16.h),
            child: HFilledButton(
              enabled: viewmodel.state.canEnableSignupButton(),
              onPressed: () {
                context.goToScreen(SolveitRoutes.registrationScreen);
              },
              text: context.getLocalization()!.continuee,
            )),
        body: Stack(
          children: [
            Padding(
              padding: horizontalPadding,
              child: HScollableColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 20.h),
                Text(
                    type.isStudent()
                        ? context.getLocalization()!.student_account
                        : type.isLecturer()
                            ? "Lecturer account"
                            : type.isStaff()
                                ? "School staff"
                                : "Public account",
                    style: context.titleMedium),
                SizedBox(height: 5.h),
                Text(
                  context.getLocalization()!.enter_your_school_information_below,
                  style: context.bodySmall,
                ),
                SizedBox(height: 30.h),
                HTextField(
                  title:
                      viewmodel.state.schoolName ?? context.getLocalization()!.select_your_school,
                  readOnly: true,
                  onTap: () async {
                    bool success = schoolViewModel.schoolResponse != null
                        ? true
                        : await schoolViewModel.getSchools();
                    if (success && context.mounted) {
                      context.showBottomSheet(SchoolSelectionBottomSheet(
                        viewmodel: viewmodel,
                        schoolViewModel: schoolViewModel,
                        type: 'school',
                      ));
                    }
                  },
                  suffixIcon: Icon(Icons.keyboard_arrow_down, size: 20.w),
                ),
                SizedBox(height: 20.h),
                // if (type.isStudent() ||
                //     type.isLecturer() ||
                //     type.isStaff()) ...[
                HTextField(
                  title: viewmodel.state.facultyName ?? 'Faculty',
                  readOnly: true,
                  onTap: () async {
                    if (schoolViewModel.schoolId != null) {
                      bool success = schoolViewModel.facultyResponse != null
                          ? true
                          : await schoolViewModel.getFaculties();
                      if (success && context.mounted) {
                        context.showBottomSheet(
                          SchoolSelectionBottomSheet(
                            schoolViewModel: schoolViewModel,
                            viewmodel: viewmodel,
                            type: 'fac',
                          ),
                        );
                      }
                    }
                  },
                  suffixIcon: Icon(Icons.keyboard_arrow_down, size: 20.w),
                ),
                SizedBox(height: 20.h),
                // ],
                if (type.isStudent()) ...[
                  HTextField(
                    title: viewmodel.state.departmentName ?? 'Department',
                    readOnly: true,
                    onTap: () async {
                      if (schoolViewModel.facultyId != null) {
                        bool success = schoolViewModel.departmentResponse != null
                            ? true
                            : await schoolViewModel.getDepartments();
                        if (success && context.mounted) {
                          context.showBottomSheet(
                            SchoolSelectionBottomSheet(
                              viewmodel: viewmodel,
                              schoolViewModel: schoolViewModel,
                              type: 'dep',
                            ),
                          );
                        }
                      }
                    },
                    suffixIcon: Icon(Icons.keyboard_arrow_down, size: 20.w),
                  ),
                  SizedBox(height: 20.h),
                  HTextField(
                      title:
                          viewmodel.state.level != null ? '${viewmodel.state.levelName}' : "Level",
                      readOnly: true,
                      suffixIcon: Icon(Icons.keyboard_arrow_down, size: 20.w),
                      onTap: () async {
                        if (schoolViewModel.schoolId != null) {
                          bool success = schoolViewModel.levelsResponse != null
                              ? true
                              : await schoolViewModel.getLevels();
                          if (success && context.mounted) {
                            context.showBottomSheet(
                              SchoolSelectionBottomSheet(
                                viewmodel: viewmodel,
                                schoolViewModel: schoolViewModel,
                                type: 'lev',
                              ),
                            );
                          }
                        }
                      }),
                  SizedBox(height: 20.h),
                  HTextField(
                    hideBorder: false,
                    title: 'Matric Number',
                    value: viewmodel.state.matricNo,
                    error: viewmodel.state.matricNoError,
                    onChange: (value) {
                      viewmodel.state.inputType = LoginInputType.matric;
                      viewmodel.onTextFieldChanged(value);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (viewmodel.state.image == null)
                    InkWell(
                        onTap: () {
                          pickImage().then((s) {
                            if (s != null) {
                              viewmodel.setImage(s);
                            }
                          });
                        },
                        child: Image.asset(choosePassport))
                  else
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20.sp),
                            child: Image.file(viewmodel.state.image!)),
                        Positioned(
                          right: 20.w,
                          top: 20.h,
                          child: ElevatedButton(
                              onPressed: () {
                                (viewmodel.setImage(null));
                                pickImage().then((s) {
                                  if (s != null) {
                                    viewmodel.setImage(s);
                                  }
                                });
                              },
                              child: const Text('Replace')),
                        )
                      ],
                    ),
                  SizedBox(
                    height: 30.h,
                  )
                ]
              ]),
            ),
            if (context.watch<SchoolViewModel>().isLoading) const Center(child: AppLoader())
          ],
        ),
      );
    });
  }
}

class SchoolSelectionBottomSheet extends StatefulWidget {
  const SchoolSelectionBottomSheet({
    super.key,
    required this.type,
    required this.viewmodel,
    required this.schoolViewModel,
  });

  final RegistrationViewModel viewmodel;
  final SchoolViewModel schoolViewModel;
  final String type;
  @override
  State<SchoolSelectionBottomSheet> createState() => _SchoolSelectionBottomSheetState();
}

String _selectedSchool = "";
List<String> data = [];
List<String> ids = [];

class _SchoolSelectionBottomSheetState extends State<SchoolSelectionBottomSheet> {
  String searchQuery = "";
  String title = "";

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case "school":
        title = "Select your school";
        data = widget.schoolViewModel.schoolResponse?.data.map((e) => e.name.toString()).toList() ??
            [];
        ids =
            widget.schoolViewModel.schoolResponse?.data.map((e) => e.id.toString()).toList() ?? [];
        break;
      case "fac":
        title = "Select your faculty";
        data = widget.schoolViewModel.facultyResponse?.data
                .where((faculty) => faculty.schoolId.toString() == widget.schoolViewModel.schoolId!)
                .map((e) => e.name.toString())
                .toList() ??
            [];
        ids = widget.schoolViewModel.facultyResponse?.data
                .where((faculty) => faculty.schoolId.toString() == widget.schoolViewModel.schoolId!)
                .map((e) => e.id.toString())
                .toList() ??
            [];
        break;
      case "dep":
        title = "Select your department";
        data = widget.schoolViewModel.departmentResponse?.data
                .where((dep) =>
                    (dep.schoolId.toString() == widget.schoolViewModel.schoolId!) &&
                    (dep.facultyId.toString() == widget.schoolViewModel.facultyId!))
                .map((e) => e.name.toString())
                .toList() ??
            [];
        ids = widget.schoolViewModel.departmentResponse?.data
                .where((dep) =>
                    (dep.schoolId.toString() == widget.schoolViewModel.schoolId!) &&
                    (dep.facultyId.toString() == widget.schoolViewModel.facultyId!))
                .map((e) => e.id.toString())
                .toList() ??
            [];
        break;
      case "lev":
        title = "Select your level";
        data = widget.schoolViewModel.levelsResponse?.data
                .where((level) => level.schoolId.toString() == widget.schoolViewModel.schoolId!)
                .map((e) => e.name.toString())
                .toList() ??
            [];
        ids = widget.schoolViewModel.levelsResponse?.data
                .where((level) => level.schoolId.toString() == widget.schoolViewModel.schoolId!)
                .map((e) => e.id.toString())
                .toList() ??
            [];
        break;
      default:
    }
    return Container(
      padding: EdgeInsets.all(16.w),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.titleSmall,
              ),
              IconButton(
                icon: SvgPicture.asset(closeIconSvg),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _selectedSchool = '');
                },
              ),
            ],
          ),
          HTextField(
            onChange: (value) => setState(() => searchQuery = value),
            hint: "Search...",
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final school = data[index];
                final id = ids[index];
                if (searchQuery.isNotEmpty &&
                    !school.toLowerCase().contains(searchQuery.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  leading: CircleAvatar(
                    child: Text(school.substring(0, 1)),
                  ),
                  title: Text(
                    school,
                    style: context.bodySmall,
                  ),
                  tileColor: _selectedSchool == school ? Colors.purple.shade50 : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  onTap: () {
                    switch (widget.type) {
                      case "school":
                        widget.viewmodel.state.school = id;
                        widget.viewmodel.state.schoolName = school;
                        widget.schoolViewModel.state.schoolId = id;

                        break;
                      case "fac":
                        widget.viewmodel.state.facultyName = school;
                        widget.viewmodel.state.faculty = id;
                        widget.schoolViewModel.state.facultyId = id;
                        break;
                      case "dep":
                        widget.viewmodel.state.departmentName = school;
                        widget.viewmodel.state.department = id;
                        widget.schoolViewModel.state.departmentId = id;
                        break;
                      case "lev":
                        widget.viewmodel.state.levelName = school;
                        widget.viewmodel.state.level = id;
                        widget.schoolViewModel.state.levelId = id;
                        break;
                      default:
                    }
                    _selectedSchool = school;
                    widget.viewmodel.updateUi();
                    context.pop();
                    setState(() => _selectedSchool = '');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
