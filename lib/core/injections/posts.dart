import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/posts/data/api/posts_api.dart';
import 'package:solveit/features/posts/domain/posts_service.dart';
import 'package:solveit/features/posts/presentation/viewmodels/comment_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/posts_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';

final postsApi = sl<PostsApi>();
final postsService = sl<PostsService>();
final postsViewModel = sl<PostsViewmodel>();
final singlePostViewModel = sl<SinglePostViewModel>();
final singlePostCommentViewModel = sl<SinglePostCommentsViewModel>();

class PostsInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<PostsApi>(() => PostsApiImplementation());
    sl.registerLazySingleton<PostsService>(() => PostsServiceImplementation());

    sl.registerLazySingleton<PostsViewmodel>(() => PostsViewmodel());
    sl.registerLazySingleton<SinglePostViewModel>(() => SinglePostViewModel());
    sl.registerFactory<SinglePostCommentsViewModel>(() => SinglePostCommentsViewModel());
  }
}
