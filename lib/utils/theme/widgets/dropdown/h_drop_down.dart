import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/image/hnetwork_image.dart';
import 'package:solveit/utils/extensions.dart';

class HPair {
  final String name;
  final String value;
  final String? icon;
  final String? svg;

  HPair(this.name, this.value, {this.icon, this.svg});
}

class HListValueDropDown extends StatefulWidget {
  final List<HPair> listItem;
  final List<String> selectedItems;
  final Function(String?) onChange;

  final String? hint;
  final Widget? errorWidget;
  final bool? showIcon;
  final String? title;

  const HListValueDropDown({
    super.key,
    required this.onChange,
    required this.listItem,
    required this.selectedItems,
    this.hint,
    this.errorWidget,
    this.title,
    this.showIcon = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _IkookListValueDropdownState();
  }
}

class _IkookListValueDropdownState extends State<HListValueDropDown> {
  bool fetched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.w),
      ),
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                widget.title ?? "",
                style: context.bodySmall?.copyWith(fontSize: 10.sp),
              ),
            ),
          DropdownButtonFormField2(
            alignment: Alignment.centerLeft,
            isExpanded: false,
            isDense: false,
            decoration: InputDecoration(
              hintText: "",

              contentPadding: EdgeInsets.zero,
              filled: false,
              // constraints: BoxConstraints(minHeight: 0.h),
              isCollapsed: true,
              fillColor: context.colorScheme.surface,
            ),
            buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(10.w),
                boxShadow: [BoxShadow(color: Colors.black26.withValues(alpha: (0.1)), blurRadius: 15, spreadRadius: 1.w)],
                border: Border.all(
                  color: context.surfaceOnBackground.withValues(alpha: (0.2)),
                ),
              ),
            ),
            hint: Text(
              widget.hint ?? "",
              style: context.bodySmall?.copyWith(color: SolveitColors.textColorHint),
            ),
            items: widget.listItem.asMap().entries.map((valu) {
              // final index = valu.key;
              final e = valu.value;
              return DropdownMenuItem<String>(
                value: e.value,
                child: widget.showIcon == true
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            if (e.icon != null && e.svg == null)
                              e.icon!.endsWith(".svg")
                                  ? SvgPicture.network(
                                      e.icon!,
                                      width: 24.w,
                                      height: 24.h,
                                    )
                                  : Hnetworkimage(image: e.icon!, width: 20.w, height: 20.w),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                e.name,
                                style: context.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        e.name,
                        style: context.bodyMedium,
                      ),
              );
            }).toList(),
            value: widget.selectedItems.isNotEmpty ? widget.listItem.firstWhereOrNull((element) => widget.selectedItems.contains(element.value))?.value : null,
            onChanged: (String? value) {
              widget.onChange(value);
            },
            selectedItemBuilder: (context) {
              return widget.listItem.map(
                (item) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        ...widget.selectedItems.map((e) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                  child: Text(
                                    widget.listItem.firstWhereOrNull((element) => e == (element.value))?.name ?? e,
                                    style: context.bodySmall,
                                  )),
                            ))
                      ]),
                    ),
                  );
                },
              ).toList();
            },
            iconStyleData: IconStyleData(
              icon: FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 10.w,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
                height: 30.h,
                selectedMenuItemBuilder: (context, child) => Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                      ),
                      child: child,
                    )),
          ),
        ],
      ),
    );
  }
}
