import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/utils/getters.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLevel = "200L";
  String role = 'Student';
  bool _isLoadingForums = false;
  bool _isUpdatingLevel = false;
  List<Map<String, dynamic>> _userForums = [];
  String? _forumsError;

  @override
  void initState() {
    super.initState();
    getAllSchoolElements(context);
    _loadUserForums();
  }

  Future<void> _loadUserForums() async {
    setState(() {
      _isLoadingForums = true;
      _forumsError = null;
    });

    try {
      final result = await authApi.getUserForums();
      result.fold(
        (failure) {
          setState(() {
            _isLoadingForums = false;
            _forumsError = failure.message ?? 'Failed to load forums';
          });
        },
        (response) {
          try {
            final forumsData = response['data'] as List<dynamic>? ?? [];
            setState(() {
              _isLoadingForums = false;
              _userForums = forumsData.map((f) => f as Map<String, dynamic>).toList();
              _forumsError = null;
            });
          } catch (e) {
            setState(() {
              _isLoadingForums = false;
              _forumsError = 'Failed to parse forums data';
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingForums = false;
        _forumsError = 'Error loading forums: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserStateManager>().state.token.user;

    switch (user?.roleId) {
      case 1:
        role = 'Student';
        break;
      case 2:
        role = 'Lecturer';
        break;
      case 3:
        role = 'Staff';
        break;
      case 4:
        role = 'Other';
        break;
      default:
        role = 'Student';
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xffFEF0F8), Color(0xffFEF0F8)]),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: backButton(context),
          actions: [
            InkWell(
                onTap: () {
                  context.read<UserStateManager>().logout(context);
                },
                child: const Icon(Icons.logout)),
            SizedBox(width: 16.w),
            const Icon(Icons.more_horiz, color: Colors.black),
            SizedBox(width: 16.w),
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Profile Picture & Name
              AvatarWidget(
                radius: 40.sp,
              ),
              const SizedBox(height: 10),
              Text(
                user?.name ?? 'N/A',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // 🔹 School Details Card
              _buildSchoolDetails(user),

              const SizedBox(height: 16),

              // 🔹 Referral Code Section
              _buildReferralCode(),

              const SizedBox(height: 40),

              // 🔹 Current Forums
              _buildCurrentForums(),

              const SizedBox(height: 20),

              const HFilledButton(
                text: "Become a vendor",
              )
            ],
          ),
        ),
      ),
    );
  }

  /// **📌 School Details Card**
  Widget _buildSchoolDetails(UserData? user) {
    final schoolId =
        adminViewmodel.state.schoolsResponse?.data.firstWhere((e) => e.id == user?.schoolId).id ??
            0;
    final school =
        adminViewmodel.state.schoolsResponse?.data.firstWhere((e) => e.id == user?.schoolId).name ??
            'N/A';
    final dept = adminViewmodel.state.departmentsResponse?.data
            .firstWhere((e) => (e.id == user?.departmentId && schoolId == user?.schoolId))
            .name ??
        'N/A';
    final level =
        adminViewmodel.state.levelsResponse?.data.firstWhere((e) => e.id == user?.schoolId).name;
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xff390021), Color(0xff9F005C)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "School details",
                style: context.bodySmall?.copyWith(
                  color: context.cardColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                    color: context.primaryColor, borderRadius: BorderRadius.circular(10.sp)),
                child: GestureDetector(
                  onTap: () => _showLevelSelectionSheet(),
                  child: Row(
                    children: [
                      SvgPicture.asset(editSvg),
                      Text(
                        " Edit",
                        style: context.bodySmall?.copyWith(
                          color: context.cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Indicator
          Row(
            children: [
              Expanded(child: _buildProgressBar(isActive: true)),
              Expanded(child: _buildProgressBar(isActive: true)),
              Expanded(child: _buildProgressBar(isActive: false)),
              Expanded(child: _buildProgressBar(isActive: false)),
            ],
          ),

          const SizedBox(height: 10),

          // School Details
          _buildDetailRow("School", school),
          _buildDetailRow("Department", dept),
          _buildDetailRow("Level", level ?? selectedLevel, showDot: true),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required bool isActive}) {
    return Container(
      height: 5,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool showDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.bodySmall?.copyWith(
              color: context.cardColor,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: context.bodySmall
                    ?.copyWith(color: context.cardColor, fontWeight: FontWeight.bold),
              ),
              if (showDot)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.circle, size: 8, color: Colors.orange),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// **📌 Referral Code Section**
  Widget _buildReferralCode() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.h,
        children: [
          Text(
            "Earn N1,000 for each referral",
            style: context.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your referral code:", style: context.bodySmall),
              Row(
                spacing: 10.w,
                children: [
                  Text(
                    "SOLVE23",
                    style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.copy, size: 15.sp, color: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **📌 Current Forums**
  Widget _buildCurrentForums() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current forums",
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_isLoadingForums)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_forumsError != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _forumsError!,
              style: TextStyle(color: Colors.red),
            ),
          )
        else if (_userForums.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No forums yet",
              style: context.bodySmall?.copyWith(color: Colors.grey),
            ),
          )
        else
          ..._userForums.take(5).map((forum) {
            final name = forum['name'] as String? ?? 'Unknown';
            final memberCount = forum['member_count'] as int? ?? 0;
            return _buildForumCard(name, "$memberCount students");
          }),
      ],
    );
  }

  Widget _buildForumCard(String title, String subtitle) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          title,
          style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8.0.w),
          child: Row(
            spacing: 14.w,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 10.sp,
                    backgroundImage: const CachedNetworkImageProvider(
                      "https://i.pravatar.cc/300",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 10.sp,
                      backgroundImage: const CachedNetworkImageProvider(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 10.sp,
                      backgroundImage: const CachedNetworkImageProvider(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                subtitle,
                style: context.bodySmall?.copyWith(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelSelectionSheet() {
    final levels = adminViewmodel.state.levelsResponse?.data ?? [];
    final userLevelId = context.read<UserStateManager>().state.token.user?.levelId;
    
    // Get current level name
    String currentLevelName = selectedLevel;
    if (userLevelId != null) {
      final currentLevel = levels.firstWhere(
        (l) => l.id == userLevelId,
        orElse: () => levels.first,
      );
      currentLevelName = currentLevel.name;
    }

    context.showBottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          String tempSelectedLevel = currentLevelName;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update level",
                      style: context.titleSmall,
                    ),
                    IconButton(
                      icon: SvgPicture.asset(closeIconSvg),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                if (levels.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No levels available"),
                  )
                else
                  ...levels.map((level) {
                    return RadioListTile(
                      title: Text(level.name),
                      value: level.name,
                      groupValue: tempSelectedLevel,
                      onChanged: (value) {
                        setState(() {
                          tempSelectedLevel = value!;
                        });
                      },
                    );
                  }),
                const SizedBox(height: 16),
                HFilledButton(
                  text: _isUpdatingLevel ? "Updating..." : "Update",
                  onPressed: _isUpdatingLevel ? null : () async {
                    final selectedLevelObj = levels.firstWhere(
                      (l) => l.name == tempSelectedLevel,
                      orElse: () => levels.first,
                    );
                    
                    await _updateLevel(selectedLevelObj.id);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateLevel(int levelId) async {
    setState(() {
      _isUpdatingLevel = true;
    });

    try {
      final result = await authApi.updateLevel(levelId);
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message ?? 'Failed to update level'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            _isUpdatingLevel = false;
          });
        },
        (response) async {
          try {
            // Update user data in state
            final userData = response['data'] as Map<String, dynamic>?;
            if (userData != null) {
              // Refresh profile to get updated user data
              final refreshResult = await authApi.refreshProfile();
              refreshResult.fold(
                (failure) {
                  log('Failed to refresh profile: ${failure.message}');
                },
                (refreshResponse) {
                  final updatedUserData = refreshResponse['data'] as Map<String, dynamic>?;
                  if (updatedUserData != null) {
                    // Update UserData and save to token
                    final userManager = sl<UserStateManager>();
                    final currentToken = userManager.state.token;
                    final updatedUser = UserData.fromMap(updatedUserData);
                    // Note: You may need to update the token with new user data
                    // This depends on your UserToken implementation
                  }
                },
              );
            }

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Level updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                selectedLevel = userData?['level']?['name'] as String? ?? selectedLevel;
              });
            }
            setState(() {
              _isUpdatingLevel = false;
            });
          } catch (e) {
            log('Error parsing update response: $e');
            setState(() {
              _isUpdatingLevel = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating level: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isUpdatingLevel = false;
      });
    }
  }
}
