class Message {
  final int id;
  final String title;
  final String subtitle;

  Message({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      title: json['text'],
      subtitle: json['sender'],
    );
  }
}
