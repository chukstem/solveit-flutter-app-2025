import 'package:solveit/features/forum/domain/models/res/forum_chat.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';

const onboardingString1 = 'Earn, connect,';
const onboardingString2 = ' and thrive with Solve-It.';
const onboardingString3 = ' Sell your skills';
const onboardingString4 = ' buy and sell items, and stay updated with';
const onboardingString5 = ' the latest news';
const onboardingString6 = ' in your school and department.';

const onboardingString7 = 'Campus life just got smarter';
const onboardingString8 = '\nlet\'s solve it!';

const kInternetConnectionError = 'No internet connection, try again.';
const kTimeOutError = 'Please check your internet conenction.';
const kServerError = 'Something went wrong, try again.';
const kFormatError = 'Unable to process data at this time.';
const kUnAuthorizedError = 'Session expired, please login to proceed.';
const kDefaultError = 'Oops something went wrong!';
const kBadRequestError = 'Bad request, please try again.';
const kNotFoundError = 'An error occured, please try again.';
const kRequestCancelledError = 'Request to server was cancelled.';
const unknownErrorString = 'An unknow error has occured, try again later';

const appBaseUrl = "https://backend.solve-it.com.ng/api/v1/";

// final List<SinglePostComments> singlePostComments = [
//   SinglePostComments(
//       name: "Bessie Cooper",
//       avatarUrl: "https://i.pravatar.cc/150?img=1",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 34,
//       isOnline: true,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: true),
//   SinglePostComments(
//       name: "Annette Black",
//       avatarUrl: "https://i.pravatar.cc/150?img=2",
//       content: "Lorem ipsum dolor sit amet, consecteturv... read more",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 34,
//       isOnline: true,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 34,
//       mediaUrl: [],
//       isOnline: false,
//       hasReplied: false,
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       isOnline: true,
//       replies: 34,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: false),
// ];

// final List<SinglePostComments> singlePostSubComments = [
//   SinglePostComments(
//       name: "Bessie Cooper",
//       avatarUrl: "https://i.pravatar.cc/150?img=1",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       isOnline: false,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: true),
//   SinglePostComments(
//       name: "Annette Black",
//       avatarUrl: "https://i.pravatar.cc/150?img=2",
//       content: "Lorem ipsum dolor sit amet, consecteturv... read more",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: false,
//       mediaUrl: [],
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: true,
//       mediaUrl: [],
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: false,
//       mediaUrl: [],
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: true,
//       mediaUrl: [],
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       mediaUrl: [],
//       isOnline: true,
//       hasReplied: false,
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       isOnline: true,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: false,
//       mediaUrl: [],
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       isOnline: true,
//       hasReplied: false,
//       mediaUrl: [],
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: true,
//       mediaUrl: [],
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: true,
//       mediaUrl: [],
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: false,
//       mediaUrl: [],
//       hasLiked: false),
//   SinglePostComments(
//       name: "Kathryn Murphy",
//       avatarUrl: "https://i.pravatar.cc/150?img=3",
//       content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       hasReplied: false,
//       isOnline: false,
//       mediaUrl: [],
//       hasLiked: true),
//   SinglePostComments(
//       name: "Guy Hawkins",
//       avatarUrl: "https://i.pravatar.cc/150?img=4",
//       content: "Be the first to SinglePostComments",
//       timeAgo: DateTime.now(),
//       likes: 34,
//       replies: 0,
//       isOnline: true,
//       mediaUrl: [],
//       hasReplied: false,
//       hasLiked: false),
// ];

final singleDummyChats = [
  SingleChatModel(
      avatarUrl: 'https://i.pravatar.cc/140?img=3',
      chatId: 1,
      chats: [
        ChatModel(
          isMine: false,
          mediaUrls: [],
          text:
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumdfdf''',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'Hi, how\'re you doing today?',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: false,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          timeAgo: DateTime.now(),
        ),
      ],
      isOnline: true,
      isVerified: true,
      name: 'Kathryn Murphy',
      type: 'Vendor'),
  SingleChatModel(
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      chatId: 2,
      chats: [
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'Hi, how\'re you doing today?',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: false,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'Hi, how\'re you doing today?',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: false,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          timeAgo: DateTime.now(),
        ),
      ],
      isOnline: true,
      isVerified: true,
      name: 'John Champion',
      type: 'Vendor'),
  SingleChatModel(
      avatarUrl: 'https://i.pravatar.cc/130?img=4',
      chatId: 3,
      chats: [
        ChatModel(
          isMine: false,
          mediaUrls: [],
          chatReply: ChatReply(name: 'You', content: 'Just a random text to test the flow of the chat replies', mediaUrls: ['https://i.pravatar.cc/150?img=3']),
          text: 'Hi, how\'re you doing today?',
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          chatReply: ChatReply(
              name: 'Malvin Yick', content: 'Just a random text to test the flow of the chat replies', mediaUrls: ['https://i.pravatar.cc/150?img=3']),
          product: Product(name: 'Very Nice Bag', mediaurls: ['https://picsum.photos/200/300'], price: '1200', place: 'Enugu'),
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: true,
          mediaUrls: [],
          text: 'Hi, how\'re you doing today?',
          chatReply: ChatReply(
              name: 'Malvin Yick', content: 'Just a random text to test the flow of the chat replies', mediaUrls: ['https://i.pravatar.cc/150?img=3']),
          timeAgo: DateTime.now(),
        ),
        ChatModel(
          isMine: false,
          mediaUrls: [],
          text: 'I am fine, thanks for asking',
          product: Product(name: 'Very Nice Bag', mediaurls: ['https://picsum.photos/200/300'], price: '1200', place: 'Enugu'),
          timeAgo: DateTime.now(),
        ),
      ],
      isOnline: true,
      name: 'Mikhailo Mudryk',
      type: 'Vendor'),
];

final List<ForumChatModel> forums = [
  ForumChatModel(
    chatId: 1,
    forumPicUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
    title: 'Computer Science',
    avatarUrls: [
      'https://randomuser.me/api/portraits/men/11.jpg',
      'https://randomuser.me/api/portraits/women/11.jpg',
      'https://randomuser.me/api/portraits/women/10.jpg',
    ],
    students: 232,
    unread: 2,
    chats: [
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text:
            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumdfdf''',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'I am fine, thanks for asking',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'Hi, how\'re you doing today?',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'I am fine, thanks for asking',
        timeAgo: DateTime.now(),
      ),
    ],
  ),
  ForumChatModel(
    chatId: 2,
    forumPicUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
    title: 'Physilogy',
    avatarUrls: [
      'https://randomuser.me/api/portraits/men/11.jpg',
      'https://randomuser.me/api/portraits/women/11.jpg',
      'https://randomuser.me/api/portraits/women/10.jpg',
    ],
    students: 100,
    unread: 1,
    chats: [
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text:
            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumdfdf''',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'I am fine, thanks for asking',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'Hi, how\'re you doing today?',
        timeAgo: DateTime.now(),
      ),
      ChatModel(
        isMine: false,
        mediaUrls: [],
        text: 'I am fine, thanks for asking',
        timeAgo: DateTime.now(),
      ),
    ],
  )
];
