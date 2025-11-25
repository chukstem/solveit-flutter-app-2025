import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/home/presentation/viewmodel/notification.dart';

final homeViewmodels = <SingleChildWidget>[
  ChangeNotifierProvider<NotificationsViewModel>(
      create: (_) => sl<NotificationsViewModel>()),
];
