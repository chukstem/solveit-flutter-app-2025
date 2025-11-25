import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/posts/presentation/viewmodels/comment_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/playback.dart';
import 'package:solveit/features/posts/presentation/viewmodels/posts_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/features/posts/presentation/viewmodels/record.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';

final postsViewmodels = <SingleChildWidget>[
  ChangeNotifierProvider<PostsViewmodel>(
    create: (_) => sl<PostsViewmodel>(),
  ),
  ChangeNotifierProvider<SinglePostViewModel>(
    create: (_) => sl<SinglePostViewModel>(),
  ),
  ChangeNotifierProvider<SinglePostCommentsViewModel>(
    create: (_) => sl<SinglePostCommentsViewModel>(),
  ),
  ChangeNotifierProvider<MediaPreviewViewModel>(
    create: (_) => sl<MediaPreviewViewModel>(),
  ),
  ChangeNotifierProvider<RecordingViewModel>(
    create: (_) => sl<RecordingViewModel>(),
  ),
  ChangeNotifierProvider<AudioPlaybackManager>(
    create: (_) => sl<AudioPlaybackManager>(),
  ),
  ChangeNotifierProvider<InputfieldViewmodel>(
    create: (_) => sl<InputfieldViewmodel>(),
  ),
];
