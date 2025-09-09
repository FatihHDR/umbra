import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/providers.dart';
import 'application/chat_view_model.dart';

final chatViewModelProvider =
    NotifierProvider.family<ChatViewModel, ChatState, String?>(
        ChatViewModel.new);
