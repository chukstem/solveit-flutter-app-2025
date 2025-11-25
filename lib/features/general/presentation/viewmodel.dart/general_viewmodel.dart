import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/general.dart';

class GeneralState {
  final bool isLoading;
  final String errorMessage;

  const GeneralState({
    this.isLoading = false,
    this.errorMessage = '',
  });

  GeneralState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return GeneralState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static const empty = GeneralState();
}

class GeneralViewmodel extends ChangeNotifier {
  GeneralState _state = GeneralState.empty;
  GeneralState get state => _state;

  void _setState(GeneralState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> retrieveFile(String query) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await generalService.retrieveFile(query);
    return result.fold((l) {
      _setState(_state.copyWith(isLoading: false, errorMessage: l.toString()));
      return false;
    }, (r) {
      _setState(_state.copyWith(isLoading: false));
      return true;
    });
  }
}
