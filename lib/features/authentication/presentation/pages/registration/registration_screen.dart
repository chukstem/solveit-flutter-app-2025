import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/admin/data/models/responses/roles/response.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/loaders.dart';

class SignUpCardModel {
  final String title;
  final String icon;
  final String enumString;

  SignUpCardModel({required this.title, required this.icon, required this.enumString});
}

final signUpCards = [
  SignUpCardModel(title: "Student", icon: studentIconSvg, enumString: "student"),
  SignUpCardModel(title: "Lecturer", icon: lecturerIconSvg, enumString: "lecturer"),
  SignUpCardModel(title: "School staff", icon: schoolStaffSvg, enumString: "staff"),
  SignUpCardModel(title: "Other user", icon: otherUserSvg, enumString: "other"),
];

class RegistrationScreenHome extends StatefulWidget {
  const RegistrationScreenHome({super.key});

  @override
  State<RegistrationScreenHome> createState() => _RegistrationScreenHomeState();
}

class _RegistrationScreenHomeState extends State<RegistrationScreenHome> {
  @override
  void initState() {
    super.initState();
    final adminViewModel = context.read<AdminViewModel>();
    if (adminViewModel.state.rolesResponse == null) adminViewModel.getRoles();
  }

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.watch<AdminViewModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 45.w,
        leading: backButton(
          context,
        ),
      ),
      body: Padding(
        padding: horizontalPadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20.h,
          ),
          Text(context.getLocalization()!.create_account, style: context.titleMedium),
          SizedBox(
            height: 5.h,
          ),
          Text(
            context.getLocalization()!.select_account_type,
            style: context.bodySmall,
          ),
          SizedBox(
            height: 15.h,
          ),
          if (adminViewModel.state.isLoading)
            const Center(child: AppLoader())
          else
            Expanded(
              child: Column(
                children: [
                  if (adminViewModel.state.rolesResponse != null)
                    Expanded(
                      child: GridView(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 20.w, mainAxisSpacing: 20.w),
                          children: (adminViewModel.state.rolesResponse!.data.isNotEmpty
                                  ? adminViewModel.state.rolesResponse!.data.sublist(
                                      0, adminViewModel.state.rolesResponse!.data.length - 1)
                                  : adminViewModel.state.rolesResponse!.data)
                              .map((e) => _signUpCard(context, e, () {
                                    context.read<RegistrationViewModel>().state.role =
                                        e.id.toString();
                                    context.goToScreen(SolveitRoutes.instituteRegistrationRoute,
                                        params: [e.name]);
                                  }))
                              .toList()),
                    )
                  else
                    const Center(
                      child: Text(
                        '🥹Unable to fetch roles, try again later.\nWho do you think missed this. Developer or QA?🤔',
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              ),
            )
        ]),
      ),
    );
  }
}

Widget _signUpCard(BuildContext context, RoleData model, VoidCallback onClick) {
  String iconPath;
  switch (model.name) {
    case "student":
      iconPath = studentIconSvg;
      break;
    case "lecturer":
      iconPath = lecturerIconSvg;
      break;
    case "staff":
      iconPath = schoolStaffSvg;
      break;
    case "other":
      iconPath = otherUserSvg;
      break;
    default:
      iconPath = studentIconSvg;
  }
  return GestureDetector(
    onTap: () => onClick(),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defRadius),
        color: context.colorScheme.surfaceContainer,
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 26.w,
            height: 26.h,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(model.name.capitalize(), style: context.bodySmall)
        ],
      ),
    ),
  );
}
