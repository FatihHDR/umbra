enum MessageRole { system, user, assistant }

class Message {
  final MessageRole role;
  final String content;

  const Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: MessageRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => MessageRole.user,
        ),
        content: json['content'] ?? '',
      );
}
