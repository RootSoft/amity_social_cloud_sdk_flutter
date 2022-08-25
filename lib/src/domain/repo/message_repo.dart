import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/core/model/api_request/create_message_request.dart';
import 'package:amity_sdk/src/domain/model/message/amity_message.dart';

/// Message Repo
abstract class MessageRepo {
  /// Query Message
  Future<PageListData<List<AmityMessage>, String>> queryMesssage(
      MessageQueryRequest request);
  Future<AmityMessage> createMessage(CreateMessageRequest request);
  Stream<List<AmityMessage>> listentMessages(MessageQueryRequest request);
  bool hasLocalMessage(String messageId);
}