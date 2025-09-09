import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'conversation_repository.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository();
});
