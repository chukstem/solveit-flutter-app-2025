import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';
import 'package:solveit/utils/utils/utils.dart';

class FeaturedPostCarousel extends StatefulWidget {
  final List<SinglePostResponse> posts;
  final Function(SinglePostResponse post, String categoryName) onPostTap;
  final Map<dynamic, String> categoriesMap;

  const FeaturedPostCarousel({
    super.key,
    required this.posts,
    required this.onPostTap,
    required this.categoriesMap,
  });

  @override
  State<FeaturedPostCarousel> createState() => _FeaturedPostCarouselState();
}

class _FeaturedPostCarouselState extends State<FeaturedPostCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start from the middle of the collection if it has enough items
    _currentPage = widget.posts.length > 10 ? 4 : 0;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h, // Height of the carousel
      child: PageView.builder(
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        controller: _pageController,
        itemCount: widget.posts.length > 10 ? 10 : widget.posts.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final post = widget.posts[index];
          final categoryName = widget.categoriesMap[post.newsCategoryId] ?? 'Unknown Category';

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _currentPage == index ? 1 : 0.9,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () => widget.onPostTap(post, categoryName),
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Background image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        isImage(post.media) ? post.media : 'https://picsum.photos/200/300',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xBD15010C),
                              Color(0x1B15010C),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Category badge
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
