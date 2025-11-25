import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/forum/presentation/pages/widgets/call.dart';

enum CallState {
  connecting,
  connected,
  failed,
  ended,
}

class CallEvent {
  final String message;
  final DateTime timestamp;

  CallEvent(this.message) : timestamp = DateTime.now();
}

final StreamController<CallEvent> _eventController = StreamController.broadcast();
Stream<CallEvent> get callEvents => _eventController.stream;

class GroupCallState {
  final CallState callState;
  final CallState? previousState;
  final List<CallParticipant> participants;
  final Duration callDuration;
  final bool isExpanded;
  final bool isSheetOpen;
  final bool callFailed;

  const GroupCallState({
    this.callState = CallState.ended,
    this.previousState,
    this.participants = const [],
    this.callDuration = Duration.zero,
    this.isExpanded = true,
    this.isSheetOpen = false,
    this.callFailed = false,
  });

  // Helper getters
  bool get isActive => callState == CallState.connected || callState == CallState.connecting;

  GroupCallState copyWith({
    CallState? callState,
    CallState? previousState,
    List<CallParticipant>? participants,
    Duration? callDuration,
    bool? isExpanded,
    bool? isSheetOpen,
    bool? callFailed,
  }) {
    return GroupCallState(
      callState: callState ?? this.callState,
      previousState: previousState ?? this.previousState,
      participants: participants ?? this.participants,
      callDuration: callDuration ?? this.callDuration,
      isExpanded: isExpanded ?? this.isExpanded,
      isSheetOpen: isSheetOpen ?? this.isSheetOpen,
      callFailed: callFailed ?? this.callFailed,
    );
  }

  static const empty = GroupCallState();
}

class GroupCallViewModel extends ChangeNotifier {
  GroupCallState _state = GroupCallState.empty;
  GroupCallState get state => _state;

  Timer? _durationTimer;
  Timer? _connectionSimulation;
  Timer? _mockJoinTimer;
  Timer? _mockLeaveTimer;

  void _setState(GroupCallState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  CallState get callState => _state.callState;
  CallState? get previousState => _state.previousState;
  List<CallParticipant> get participants => List.unmodifiable(_state.participants);
  Duration get callDuration => _state.callDuration;
  bool get isExpanded => _state.isExpanded;
  bool get isSheetOpen => _state.isSheetOpen;
  bool get isActive => _state.isActive;

  /// Should be called after ViewModel is ready
  void startCall() {
    _setState(_state.copyWith(
      callState: CallState.connecting,
      participants: [],
      callDuration: Duration.zero,
      callFailed: false,
    ));

    _connectionSimulation = Timer(const Duration(seconds: 2), () {
      if (_state.callFailed) {
        _updateCallState(CallState.failed);
      } else {
        _updateCallState(CallState.connected);
        _startDurationTimer();
        _mockParticipants();
      }
    });
  }

  void _updateCallState(CallState state) {
    _setState(_state.copyWith(
      previousState: _state.callState,
      callState: state,
    ));
  }

  void toggleSheetSize() {
    _setState(_state.copyWith(isExpanded: !_state.isExpanded));
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _setState(_state.copyWith(callDuration: _state.callDuration + const Duration(seconds: 1)));
    });
  }

  void _mockParticipants() {
    final updatedParticipants = [
      ..._state.participants,
      CallParticipant(
        name: "Malvin",
        avatarUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      ),
      CallParticipant(
        name: "Tina",
        avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      ),
    ];

    _setState(_state.copyWith(participants: updatedParticipants));
    _eventController.add(CallEvent("Malvin joined"));
    _eventController.add(CallEvent("Tina joined"));

    _mockJoinTimer = Timer(const Duration(seconds: 4), () {
      final newParticipants = [..._state.participants];
      newParticipants.add(
        CallParticipant(
          name: "Louis",
          avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        ),
      );
      _setState(_state.copyWith(participants: newParticipants));
      _eventController.add(CallEvent("Louis joined"));
    });

    _mockLeaveTimer = Timer(const Duration(seconds: 8), () {
      if (_state.participants.isNotEmpty) {
        final newParticipants = [..._state.participants];
        _eventController.add(CallEvent("${newParticipants[0].name} left"));
        newParticipants.removeAt(0);
        _setState(_state.copyWith(participants: newParticipants));
      }
    });
  }

  void failCall() {
    _setState(_state.copyWith(callFailed: true));
    _connectionSimulation?.cancel();
    _updateCallState(CallState.failed);
  }

  void endCall(BuildContext context) {
    _cleanUp();
    _updateCallState(CallState.ended);
    Future.microtask(() {
      if (context.mounted) context.pop();
    });
  }

  void endCallWithDelay() {
    _updateCallState(CallState.ended);
    Future.delayed(const Duration(milliseconds: 800), () {
      _cleanUp();
    });
  }

  void _cleanUp() {
    _durationTimer?.cancel();
    _connectionSimulation?.cancel();
    _mockJoinTimer?.cancel();
    _mockLeaveTimer?.cancel();
    _setState(_state.copyWith(
      participants: [],
      callDuration: Duration.zero,
    ));
  }

  void markSheetOpened() {
    _setState(_state.copyWith(isSheetOpen: true));
  }

  void markSheetClosed() {
    _setState(_state.copyWith(isSheetOpen: false));
  }

  @override
  void dispose() {
    _cleanUp();
    super.dispose();
  }
}
