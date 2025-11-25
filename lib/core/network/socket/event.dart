abstract class Event {
  String name = 'event name';
  Map<String, dynamic> data() {
    return {};
  }
}

class AnEvent implements Event {
  @override
  String name = "";

  @override
  Map<String, dynamic> data() {
    return {};
  }
}
