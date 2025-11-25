import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';

getAllSchoolElements(BuildContext context) {
  if (adminViewmodel.state.schoolsResponse == null) {
    context.read<AdminViewModel>().getSchools();
    context.read<AdminViewModel>().getFaculties();
    context.read<AdminViewModel>().getDepartments();
  }
}
