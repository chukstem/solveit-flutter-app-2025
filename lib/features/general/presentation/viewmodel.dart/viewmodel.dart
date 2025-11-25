import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/general/presentation/viewmodel.dart/general_viewmodel.dart';

final generalViewModels = <SingleChildWidget>[
  ChangeNotifierProvider<GeneralViewmodel>(create: (_) => sl<GeneralViewmodel>()),
];
