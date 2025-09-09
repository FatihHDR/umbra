class ConversationSummary {
  final String id; // uuid
  final String title; // derived from first user question
  final DateTime updatedAt;

  const ConversationSummary({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ConversationSummary.fromJson(Map<String, dynamic> json) =>
      ConversationSummary(
        id: json['id'] as String,
        title: json['title'] as String,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
