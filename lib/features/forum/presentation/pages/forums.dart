import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_message_viewmodel.dart';
import 'package:solveit/features/forum/presentation/widgets/forum_app_bar.dart';
import 'package:solveit/features/forum/presentation/widgets/forum_list.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/loaders.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  Future<void> _refreshForums(BuildContext context) async {
    final vm = context.read<ForumMessageViewmodel>();
    await vm.loadForumChats();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForumMessageViewmodel>();

    return Scaffold(
      appBar: const ForumAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshForums(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: vm.isLoading && vm.forumChatModel.isEmpty
              ? const Center(child: AppLoader())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!vm.isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Active forums",
                            style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(vm.state.activeCount.toString(), style: context.bodyMedium),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ForumList(viewModel: vm),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
