import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/conversation_repository.dart';
import 'application/chat_view_model.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository();
});

final chatViewModelProvider =
    NotifierProvider.family<ChatViewModel, ChatState, String?>(
        ChatViewModel.new);
