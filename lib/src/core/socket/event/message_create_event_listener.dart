import 'package:amity_sdk/src/core/socket/event/message_event_listener.dart';

class MessageCreateEventListener extends MessageEventListener {
  @override
  String getEventName() {
    return 'v3.message.didCreate';
  }

  @override
  bool shouldProcessEvent(Map<String, dynamic> json) {
    return true;
  }
}