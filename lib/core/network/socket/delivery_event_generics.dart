import 'package:solveit/core/network/socket/event.dart';

class EventGeneric {
  static T fromJson<T>(Map<String, dynamic> json) {
    if (T == AnEvent) {
      return json as T;
    } else {
      throw Exception("Unknown class");
    }
  }
}
