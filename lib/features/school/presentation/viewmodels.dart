import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/school/presentation/school_viewmodel.dart';

final schoolsViewmodels = <SingleChildWidget>[
  ChangeNotifierProvider<SchoolViewModel>(
    create: (_) => sl<SchoolViewModel>(),
  ),
];
