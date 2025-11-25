import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class HomeSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSearchIconPressed;
  final bool readOnly;
  final String? hint;

  const HomeSearchBar({
    super.key,
    this.onTap,
    this.onSearchIconPressed,
    this.readOnly = true,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      primary: false,
      title: HTextField(
        title: hint ?? "Search",
        suffixIcon: onSearchIconPressed != null
            ? InkWell(
                onTap: onSearchIconPressed,
                child: SvgPicture.asset(searchIcon),
              )
            : const SizedBox.shrink(),
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
