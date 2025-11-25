import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';
import 'package:solveit/features/messages/presentation/widgets/messages_back_button.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

AppBar message1AppBar(BuildContext context, {required VoidCallback search, bool isSearching = false, required TextEditingController searchController}) {
  final messagesProvider = context.read<MessagesViewModel>();
  return AppBar(
    backgroundColor: context.colorScheme.primary,
    automaticallyImplyLeading: false,
    title: isSearching
        ? MessagesSearchWidget(messageProvider: messagesProvider, searchController: searchController, onDismiss: search)
        : Text(
            context.getLocalization()!.messages,
            textAlign: TextAlign.start,
            style: context.titleSmall!.copyWith(
              color: context.cardColor,
            ),
          ),
    leadingWidth: 30.w,
    leading: messagesBackButton(
      context,
      onTap: () {
        if (!isSearching) {
          messagesProvider.clearSearch();
          context.pop();
        } else {
          search();
        }
      },
    ),
    actions: isSearching
        ? []
        : [
            SizedBox(width: 16.w),
            SizedBox(
              height: 50.h,
              width: 50.w,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SvgPicture.asset(
                    headPhone,
                    width: 20.w,
                    height: 20.h,
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SolveitColors.errorColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "2",
                          style: context.headlineSmall!.copyWith(
                            fontSize: 10,
                            color: context.cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                messagesProvider.createNewChat(context);
              },
              child: SvgPicture.asset(
                newMessageSvg,
                width: 20.w,
                height: 20.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: search,
              child: SvgPicture.asset(
                searchIcon,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 16.w),
          ],
  );
}

class MessagesSearchWidget extends StatelessWidget {
  const MessagesSearchWidget({super.key, required this.searchController, required this.onDismiss, required this.messageProvider});
  final TextEditingController searchController;
  final VoidCallback onDismiss;
  final MessagesViewModel messageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.primaryColor,
      ),
      child: HTextField(
        controller: searchController,
        isDense: true,
        title: context.getLocalization()!.search_messages,
        onChange: (value) {
          if (value.isEmpty) {
            messageProvider.clearSearch();
          } else {
            messageProvider.searchSingleChatModels(value);
          }
        },
        suffixIcon: GestureDetector(
          onTap: () {
            onDismiss();
            messageProvider.clearSearch();
          },
          child: SvgPicture.asset(
            closeIconSvg,
            width: 28.w,
            height: 28.h,
          ),
        ),
      ),
    );
  }
}
