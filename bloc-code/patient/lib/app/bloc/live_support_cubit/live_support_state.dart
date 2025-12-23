part of 'live_support_cubit.dart';

class LiveSupportState extends Equatable {
  bool isLoading;
  bool isMessageSending;
  bool isNewChat;
  String supportId;
  List<LiveChat> liveChatList;
  List<LiveSupport> liveSupportList;

  LiveSupportState(
      {required this.isLoading,
      required this.isMessageSending,
      required this.isNewChat,
      required this.supportId,
      required this.liveChatList,
      required this.liveSupportList});

  @override
  List<Object> get props =>
      [liveChatList.length, liveChatList.hashCode, isLoading,isMessageSending, isNewChat, liveSupportList.length, liveSupportList.hashCode];

  LiveSupportState copyWith({
    bool? isLoading,
    bool? isMessageSending,
    bool? isNewChat,
    String? supportId,
    List<LiveChat>? liveChatList,
    List<LiveSupport>? liveSupportList,
  }) {
    return LiveSupportState(
      isLoading: isLoading ?? this.isLoading,
  isMessageSending: isMessageSending ?? this.isMessageSending,
      isNewChat: isNewChat ?? this.isNewChat,
      supportId: supportId ?? this.supportId,
      liveChatList: liveChatList ?? this.liveChatList,
      liveSupportList: liveSupportList ?? this.liveSupportList,
    );
  }
}

class MessageSentSuccessful extends LiveSupportState {
  MessageSentSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.liveChatList,
    required super.liveSupportList,
    required super.isNewChat,
    required super.supportId, required super.isMessageSending,
  });

  String toastMessage;
}

class MessageSentFailed extends LiveSupportState {
  MessageSentFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.liveChatList,
    required super.liveSupportList,
    required super.isNewChat,
    required super.supportId, required super.isMessageSending,
  });

  String errorMessage;
}

class LiveSupportListSuccessful extends LiveSupportState {
  LiveSupportListSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.liveChatList,
    required super.liveSupportList,
    required super.isNewChat,
    required super.supportId, required super.isMessageSending,
  });

  String toastMessage;
}

class LiveSupportListFailed extends LiveSupportState {
  LiveSupportListFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.liveChatList,
    required super.liveSupportList,
    required super.isNewChat,
    required super.supportId, required super.isMessageSending,
  });

  String errorMessage;
}
