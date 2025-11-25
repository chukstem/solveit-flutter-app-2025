import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/post_bottom_section.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/post_top_section.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/widgets/skeleton/h_skeleton.dart';

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({super.key});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MediaPreviewViewModel>().setPostType(PostType.posts);
    context.read<SinglePostViewModel>().loadPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<SinglePostViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.postState;
          if (state.errorMessage != null) {
            context.showError(state.errorMessage!);
            return const SizedBox.shrink();
          }

          if (viewModel.currentPost == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              HSkeleton(
                isLoading: state.isLoading,
                child: PostTopSection(
                  title: viewModel.currentPost!.title,
                  category: viewModel.currentCategory,
                  timeStamp: viewModel.currentPost!.createdAt,
                  imageUrl: viewModel.currentPost!.media,
                  onLike: viewModel.toggleLike,
                  onSave: viewModel.toggleSave,
                  onShare: viewModel.sharePost,
                ),
              ),
              PostBottomSection(
                postDetails: viewModel.currentPost!.body,
                viewModel: viewModel,
                postId: viewModel.currentPost!.id,
              ),
            ],
          );
        },
      ),
    );
  }
}
