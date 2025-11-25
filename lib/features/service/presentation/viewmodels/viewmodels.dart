import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/service/presentation/viewmodels/core_services_viewmodel.dart';
import 'package:solveit/features/service/presentation/viewmodels/details.dart';
import 'package:solveit/features/service/presentation/viewmodels/filter.dart';
import 'package:solveit/features/service/presentation/viewmodels/service_search.dart';
import 'package:solveit/features/service/presentation/viewmodels/services_viewmodel.dart';

final servicesViewModel = <SingleChildWidget>[
  ChangeNotifierProvider<ServicesViewModel>(create: (_) => sl<ServicesViewModel>()),
  ChangeNotifierProvider<ServiceFilterViewModel>(create: (_) => sl<ServiceFilterViewModel>()),
  ChangeNotifierProvider<ServicesDetailViewModel>(create: (_) => sl<ServicesDetailViewModel>()),
  ChangeNotifierProvider<ServiceSearchViewModel>(create: (_) => sl<ServiceSearchViewModel>()),
  ChangeNotifierProvider<CoreServicesViewModel>(create: (_) => sl<CoreServicesViewModel>()),
];
