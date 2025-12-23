import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/views/live_support/model/live_chat_model.dart';

import '../../api/repo/api_repo.dart';
import '../../views/live_support/model/live_support_list.dart';

part 'live_support_state.dart';

class LiveSupportCubit extends Cubit<LiveSupportState> {
  LiveSupportCubit()
      : super(LiveSupportState(liveChatList: [], isLoading: false, liveSupportList: [], isNewChat: true, supportId: '', isMessageSending: false));

  initSocket() {}

  refreshChatList(LiveChat liveChat) {
    List<LiveChat> tempLiveChat = [];
    tempLiveChat.add(liveChat);
    tempLiveChat.addAll(state.liveChatList);

    emit(LiveSupportState(
        liveChatList: tempLiveChat,
        isLoading: false,
        liveSupportList: state.liveSupportList,
        isNewChat: state.isNewChat,
        supportId: state.supportId, isMessageSending: false));
  }

  Future<void> messageSend({
    required Map<String, dynamic> parameters,
  }) async {
    emit(
      LiveSupportState(
          liveChatList: state.liveChatList,
          isLoading: false,
          liveSupportList: state.liveSupportList,
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: true),
    );
    final messegeSendResponse = await ApiRepo().messageSend(parameters: parameters);
    if (messegeSendResponse.status == 'success') {
      emit(
        MessageSentSuccessful(
            isLoading: false,
            toastMessage: messegeSendResponse.message!,
            liveChatList: state.liveChatList,
            liveSupportList: state.liveSupportList,
            isNewChat: false,
            supportId: messegeSendResponse.supportId!, isMessageSending: false),
      );
      getMessagesListBySupportId();
    } else {
      emit(
        MessageSentFailed(
            isLoading: false,
            errorMessage: messegeSendResponse.message!,
            liveChatList: state.liveChatList,
            liveSupportList: state.liveSupportList,
            isNewChat: false,
            supportId: state.supportId, isMessageSending: false),
      );
    }
  }

  Future<void> getLiveSupportList() async {
    emit(
      LiveSupportState(
          liveChatList: state.liveChatList,
          isLoading: true,
          liveSupportList: [],
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: false),
    );
    final loginApiResponseModel = await ApiRepo().fetchLiveSupportList(parameters: {"status": "inProgress"});
    if (loginApiResponseModel.status == 'success') {
      if (loginApiResponseModel.data!.docs!.isNotEmpty) {
        emit(
          LiveSupportListSuccessful(
            isLoading: false,
            toastMessage: loginApiResponseModel.message!,
            liveChatList: state.liveChatList,
            liveSupportList: loginApiResponseModel.data!.docs!,
            isNewChat: false,
            supportId: loginApiResponseModel.data!.docs!.first.id!, isMessageSending: false,
          ),
        );

        getMessagesListBySupportId();
      } else {
        emit(
          LiveSupportListSuccessful(
            isLoading: false,
            toastMessage: loginApiResponseModel.message!,
            liveChatList: state.liveChatList,
            liveSupportList: loginApiResponseModel.data!.docs!,
            isNewChat: true,
            supportId: state.supportId, isMessageSending: false,
          ),
        );
      }
    } else {
      emit(
        LiveSupportListFailed(
          isLoading: false,
          errorMessage: loginApiResponseModel.message!,
          liveChatList: state.liveChatList,
          liveSupportList: state.liveSupportList,
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: false,
        ),
      );
    }
  }

  Future<void> getMessagesListBySupportId() async {
    emit(
      LiveSupportState(
          liveChatList: state.liveChatList,
          isLoading: false,
          liveSupportList: state.liveSupportList,
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: false),
    );
    final messageListByIdResponse = await ApiRepo().messagesListBySupportId(supportId: '${state.supportId}');
    if (messageListByIdResponse.status == 'success') {
      emit(
        LiveSupportListSuccessful(
          isLoading: false,
          toastMessage: messageListByIdResponse.message!,
          liveChatList: messageListByIdResponse.data!.docs!,
          liveSupportList: state.liveSupportList,
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: false,
        ),
      );
    } else {
      emit(
        LiveSupportListFailed(
          isLoading: false,
          errorMessage: messageListByIdResponse.message!,
          liveChatList: state.liveChatList,
          liveSupportList: state.liveSupportList,
          isNewChat: state.isNewChat,
          supportId: state.supportId, isMessageSending: false,
        ),
      );
    }
  }
}
