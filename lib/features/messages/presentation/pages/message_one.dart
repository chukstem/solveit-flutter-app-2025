import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';
import 'package:solveit/features/messages/presentation/widgets/message_filter_tabs.dart';
import 'package:solveit/features/messages/presentation/widgets/messages_app_bar.dart';
import 'package:solveit/features/messages/presentation/widgets/messages_list_views.dart';

class MessageScreen1 extends StatefulWidget {
  const MessageScreen1({super.key});

  @override
  State<MessageScreen1> createState() => _MessageScreen1State();
}

class _MessageScreen1State extends State<MessageScreen1> {
  String _selectedFilter = "All Chats";
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // if (mounted) {
      //   context.read<MessagesViewModel>().loadSingleChatModels();
      // }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
    if (!isSearching) {
      searchController.clear();
    }
  }

  void _handleFilterChange(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesViewModel>(builder: (context, messagesProvider, _) {
      return Scaffold(
        appBar: message1AppBar(
          context,
          search: _toggleSearch,
          searchController: searchController,
          isSearching: isSearching,
        ),
        body: Column(
          children: [
            MessageFilterTabs(
              selectedFilter: _selectedFilter,
              onFilterChanged: _handleFilterChange,
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: _buildMessagesList(messagesProvider),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMessagesList(MessagesViewModel messagesProvider) {
    if (messagesProvider.isLoading) {
      return const LoadingMessagesListView();
    }

    if (messagesProvider.singleChatModelsError != null) {
      return Center(
        child: Text(messagesProvider.singleChatModelsError!),
      );
    }

    if (messagesProvider.singleChatModels.isEmpty) {
      return const Center(
        child: Text("No messages found"),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !messagesProvider.isSearching
          ? LoadedMessagesListView(
              viewmodel: messagesProvider, state: messagesProvider.singleChatModels)
          : LoadedMessagesListView(
              state: messagesProvider.searchedMessages,
              viewmodel: messagesProvider,
            ),
    );
  }
}
