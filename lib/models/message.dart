enum MessageRole { system, user, assistant }

class Message {
  final MessageRole role;
  final String content;

  const Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': switch (role) {
          MessageRole.system => 'system',
          MessageRole.user => 'user',
          MessageRole.assistant => 'assistant',
        },
        'content': content,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    final roleStr = (json['role'] as String?) ?? 'user';
    final role = switch (roleStr) {
      'system' => MessageRole.system,
      'assistant' => MessageRole.assistant,
      _ => MessageRole.user,
    };
    return Message(role: role, content: (json['content'] ?? '') as String);
  }
}
