import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';
import 'package:solveit/features/home/presentation/widgets/category_tabs.dart';
import 'package:solveit/features/home/presentation/widgets/featured_post_carousel.dart';
import 'package:solveit/features/home/presentation/widgets/home_app_bar.dart';
import 'package:solveit/features/home/presentation/widgets/home_search_bar.dart';
import 'package:solveit/features/home/presentation/widgets/news_widget.dart';
import 'package:solveit/features/posts/presentation/viewmodels/posts_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/loaders.dart';
import 'package:solveit/utils/utils/string_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<PostsViewmodel>().getAllPostsElements();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsViewmodel>(
      builder: (context, postViewModel, _) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: postViewModel.isLoading
                ? const Center(child: AppLoader())
                : _buildHomeContent(postViewModel),
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(PostsViewmodel postViewModel) {
    final posts = postViewModel.allPostsResponse?.data ?? [];
    final categories = postViewModel.allCategoriesResponse?.data ?? [];

    // Create a map of category ID to name for easy lookup
    final categoryMap = {for (var category in categories) category.id: category.name};

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: HomeAppBar(
            avatarUrl: 'https://picsum.photos/200',
            onMessageIconPressed: () => context.goToScreen(SolveitRoutes.messageScreen1),
            onNotificationIconPressed: () => context.goToScreen(SolveitRoutes.notificationScreen),
            onProfilePressed: () => context.goToScreen(SolveitRoutes.profileScreen),
          ),
          pinned: false,
        ),
        SliverAppBar(
          primary: false,
          flexibleSpace: HomeSearchBar(
            onTap: () => context.goToScreen(SolveitRoutes.homeScreenSearch),
          ),
        ),
        SliverToBoxAdapter(
          child: CategoryTabs(
            categories: categories.map((e) => e.name).toList(),
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        ),
        if (posts.isNotEmpty)
          SliverToBoxAdapter(
            child: FeaturedPostCarousel(
              posts: posts,
              categoriesMap: categoryMap,
              onPostTap: (post, categoryName) {
                context.read<SinglePostViewModel>().setCurrentPost(post, categoryName);
                context.goToScreen(SolveitRoutes.singlePostScreen);
              },
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Posts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to see all posts
                  },
                  child: const Text("See All"),
                ),
              ],
            ),
          ),
        ),
        // Show filtered posts based on selected category
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final filteredPosts = _selectedCategory.isEmpty
                  ? posts
                  : posts.where((post) {
                      final catName = categoryMap[post.newsCategoryId] ?? '';
                      return catName.toLowerCase() == _selectedCategory;
                    }).toList();

              if (index >= filteredPosts.length) return null;

              return Newswidget(
                post: filteredPosts[index],
                postCategory: categories,
              );
            },
            childCount: 10, // Limit to 10 items for better performance
          ),
        ),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.avatarUrl,
    this.isOnline = false,
    this.hasRing = true,
    this.hasVerified = false,
    this.hasOnline = false,
    this.radius,
  });
  final String? avatarUrl;
  final bool? isOnline, hasOnline, hasRing, hasVerified;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserStateManager>();
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: !hasRing! ? Colors.white.withValues(alpha: 0.1) : context.primaryColor)),
      padding: const EdgeInsets.all(1),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
              radius: radius ?? 15.sp,
              child: Text(
                StringUtils.getInitials(user.state.token.user?.name.split(' ').first ?? 'N/A',
                    user.state.token.user?.name.split(' ').last ?? 'N/A'),
                style: context.bodySmall?.copyWith(color: Colors.white),
              )),
          if (hasVerified!) const CircleAvatar(radius: 10, backgroundColor: Colors.white),
          if (hasVerified!) const Icon(Icons.verified, color: Colors.green, size: 18),
          if (hasOnline!)
            Icon(
              Icons.circle,
              size: 8,
              color: isOnline! ? Colors.green : Colors.grey,
            ),
        ],
      ),
    );
  }
}

Widget svgIconButton(String svg, VoidCallback onclick, {Color color = SolveitColors.textColor}) {
  return InkWell(
    onTap: () => onclick(),
    child: SvgPicture.asset(
      svg,
      width: 18.w,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
  );
}
