// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/admin.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/admin/data/models/responses/permissions/response.dart';
import 'package:solveit/features/admin/data/models/responses/roles/response.dart';

/// **Role Permissions State Model**
class RolePermissionsState {
  final List<RoleData> roles;
  final List<Permissions> permissions;
  final RoleData? selectedRole;
  final bool isLoading;
  final String? errorMessage;
  final Failure? failure;

  const RolePermissionsState({
    this.roles = const [],
    this.permissions = const [],
    this.selectedRole,
    this.isLoading = false,
    this.errorMessage,
    this.failure,
  });

  RolePermissionsState copyWith({
    List<RoleData>? roles,
    List<Permissions>? permissions,
    RoleData? selectedRole,
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
  }) {
    return RolePermissionsState(
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      selectedRole: selectedRole ?? this.selectedRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }
}

/// **RolePermissionsViewModel for Role and Permission Management**
class RolePermissionsViewModel extends ChangeNotifier {
  RolePermissionsState _state = const RolePermissionsState();
  RolePermissionsState get state => _state;

  /// ✅ **Handles API calls and updates state**
  Future<bool> _handleApiCall(Future<Either<Failure, dynamic>> Function() apiCall) async {
    _setState(isLoading: true);
    _clearErrors();

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (success) {
          if (success is GetRolesResponse) {
            _setState(roles: success.data);
          } else if (success is GetPermissionResponse) {
            _setState(permissions: success.permission);
          }
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(isLoading: false);
    }
  }

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    List<RoleData>? roles,
    List<Permissions>? permissions,
    RoleData? selectedRole,
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
  }) {
    _state = _state.copyWith(
      roles: roles,
      permissions: permissions,
      selectedRole: selectedRole,
      isLoading: isLoading,
      errorMessage: errorMessage,
      failure: failure,
    );
    Timer(const Duration(milliseconds: 30), () => notifyListeners());
  }

  /// ✅ **Clears error messages and failure objects**
  void _clearErrors() {
    _setState(
      errorMessage: null,
      failure: null,
    );
  }

  /// ✅ **Sets error information**
  void _setError(Failure failure) {
    _setState(errorMessage: failure.message, failure: failure);
  }

  /// ✅ **Load all roles from the server**
  Future<bool> loadRoles() async {
    return _handleApiCall(() => adminService.getRoles());
  }

  /// ✅ **Load all permissions from the server**
  Future<bool> loadPermissions() async {
    return _handleApiCall(() => adminService.getPermission());
  }

  /// ✅ **Select a role to manage its permissions**
  void selectRole(RoleData role) {
    _setState(selectedRole: role);
  }

  /// ✅ **Toggle a permission for the selected role**
  Future<bool> togglePermission(String permissionId, bool value) async {
    if (_state.selectedRole == null) {
      _setError(GenericFailure(message: 'No role selected'));
      return false;
    }

    _setState(isLoading: true);

    try {
      // This is a placeholder for the actual API call
      // Replace with actual implementation that calls the API service
      await Future.delayed(const Duration(milliseconds: 500));

      // After successful toggle, you might want to refresh the roles or permissions
      return true;
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(isLoading: false);
    }
  }

  /// ✅ **Load initial data**
  Future<void> loadInitialData() async {
    await loadRoles();
    await loadPermissions();
  }

  /// ✅ **Clear all state data**
  void clearSession() {
    _state = const RolePermissionsState();
    notifyListeners();
  }
}
