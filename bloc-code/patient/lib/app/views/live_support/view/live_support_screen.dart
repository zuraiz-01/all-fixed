import 'dart:developer';

import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/live_support_cubit/live_support_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/app_services.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/live_support/model/live_chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../utils/functions.dart';
import '../../global_widgets/toast.dart';
import '../../shemmer/card_skelton_screen.dart';

class LiveSupportScreen extends StatelessWidget {
  LiveSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveSupportCubit(),
      child: _LiveSupportScreen(),
    );
  }
}

class _LiveSupportScreen extends StatefulWidget {
  // final String user;

  const _LiveSupportScreen();

  @override
  _LiveSupportScreenState createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<_LiveSupportScreen> {
  late TextEditingController _messageController = TextEditingController();

  // ScrollController _controller;
  late IO.Socket socket;

  // void _sendMessage() {
  //   String messageText = _messageController.text.trim();
  //   _messageController.text = '';
  //   print(messageText);
  //   if (messageText != '') {
  //     var messagePost = {
  //       'message': messageText,
  //       'sender': "Imtiaz Amin",
  //       'recipient': 'joinSupportRoom',
  //       'time': DateTime.now().toUtc().toString().substring(0, 16)
  //     };
  //     socket.emit('joinSupportRoom', messagePost);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initSocket();
    context.read<LiveSupportCubit>().getLiveSupportList();
  }

  initSocket() {
    socket = IO.io(ApiConstants.baseUrl, <String, dynamic>{
      'path': '/socket',
      'autoConnect': false,
      'transports': ['websocket'], //polling or websocket
    });
    socket.connect();
    socket.onConnect((_) {
      log('Connection established');

      // socket.emit('joinSupportRoom', {"supportId": '64c152a7d28f33681b793437'});
    });

    socket.on('newSupportMessage', (data) {
      log("receive from data $data");

      // context.read<LiveSupportCubit>().getMessagesListBySupportId();
      context.read<LiveSupportCubit>().refreshChatList(LiveChat.fromJson(data));
    });

    socket.onDisconnect((_) => log('Connection Disconnection'));
    socket.onConnectError((err) => log('onConnectError $err'));
    socket.onError((err) => log('onError $err'));
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.60,
              child: Container(
                child: Text(
                  'Support',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<LiveSupportCubit, LiveSupportState>(
        listener: (context, state) {
          if (state is MessageSentSuccessful) {
            // showToast(
            //   message: state.toastMessage,
            //   context: context,
            // );
            // if (state.supportId.isEmpty) {
            //   socket.emit('joinSupportRoom', {"supportId": '${state.supportId}'});
            // }
            socket.emit('joinSupportRoom', {"supportId": '${state.supportId}'});
            _messageController.text = '';
          } else if (state is MessageSentFailed) {
            showToast(
              message: state.errorMessage,
              context: context,
            );
          }

          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: state.isLoading
                ? NewsCardSkelton()
                : Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 60,
                        width: size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          reverse: true,
                          // cacheExtent: 1000,
                          itemCount: state.liveChatList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return state.liveChatList[index].senderType
                                            .toString()
                                            .toUpperCase() ==
                                        "user".toUpperCase()
                                    ?
                                    // ChatBubble(
                                    //         clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                                    //         alignment: Alignment.topRight,
                                    //         margin: EdgeInsets.only(top: 5, bottom: 5),
                                    //         backGroundColor: Colors.yellow[100],
                                    //         child: Container(
                                    //           constraints: BoxConstraints(maxWidth: size.width * 0.7),
                                    //           child: Column(
                                    //             crossAxisAlignment: CrossAxisAlignment.start,
                                    //             children: [
                                    //               Text('${formatDate(state.liveChatList[index].createdAt.toString())}', style: TextStyle(color: Colors.grey, fontSize: 8)),
                                    //               Text('${state.liveChatList[index].content}', style: TextStyle(color: Colors.black, fontSize: 16))
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       )
                                    _eyeDoctorMessageUserWidget(
                                        context,
                                        '${state.liveChatList[index].content}',
                                        '${state.liveChatList[index].createdAt}')
                                    : _eyeDoctorMessageAdminWidget(
                                        context,
                                        '${state.liveChatList[index].content}',
                                        '${state.liveChatList[index].createdAt}')

                                // ChatBubble(
                                //         clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                                //         alignment: Alignment.topLeft,
                                //         margin: EdgeInsets.only(top: 5, bottom: 5),
                                //         backGroundColor: Colors.grey[100],
                                //         child: Container(
                                //           constraints: BoxConstraints(maxWidth: size.width * 0.7),
                                //           child: Column(
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Text('${formatDate(state.liveChatList[index].createdAt.toString())}', style: TextStyle(color: Colors.grey, fontSize: 8)),
                                //               Text('${state.liveChatList[index].content}', style: TextStyle(color: Colors.black, fontSize: 16))
                                //             ],
                                //           ),
                                //         ),
                                //       )
                                ;
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          // height: 60,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 1,
                                width: getWidth(context: context),
                                color: AppColors.colorEDEDED,
                              ),
                              Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: size.width * 0.80,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: TextField(
                                      controller: _messageController,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        hintText: "Type your message...",
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        // enabledBorder: UnderlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.black),
                                        // ),
                                        // focusedBorder: UnderlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.black),
                                        // ),
                                        // disabledBorder: UnderlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.grey),
                                        // ),
                                        counterText: '',
                                      ),
                                      style: TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.text,
                                      maxLength: 500,
                                    ),
                                  ),
                                  state.isMessageSending
                                      ? Container(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator())
                                      : Container(
                                          width: size.width * 0.15,
                                          decoration: BoxDecoration(
                                              color: AppColors.color9747FF,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: IconButton(
                                            icon: Icon(Icons.send,
                                                color: Colors.white),
                                            onPressed: () {
                                              if (!state.isLoading) {
                                                Map<String, dynamic>
                                                    parameters =
                                                    Map<String, dynamic>();
                                                parameters["type"] = state
                                                        .isNewChat
                                                    ? "new"
                                                    : "existing"; //new,existing
                                                parameters["content"] =
                                                    "${_messageController.text.trim()}"; //text,attachment
                                                parameters["contentType"] =
                                                    "text"; //text,attachment
                                                parameters["subject"] =
                                                    "I have a problem"; //required if type==new
                                                parameters["supportId"] =
                                                    "${state.supportId}"; //required if type=existing
                                                context
                                                    .read<LiveSupportCubit>()
                                                    .messageSend(
                                                        parameters: parameters);
                                              }

                                              // _sendMessage();
                                            },
                                          ),
                                        )
                                ],
                              ),
                              Gap(10)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}

Widget _eyeDoctorMessageAdminWidget(
    BuildContext context, String message, String createdAt) {
  return Container(
    margin: EdgeInsets.only(left: 10, bottom: 10, right: 50),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(AppAssets.beh_app_icon_with_bg),
          ),
        ),
        Gap(5),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Eye Doctor',
                  style: TextStyle(color: AppColors.color888E9D, fontSize: 11)),
              Gap(5),
              Container(
                // width: getWidth(context: context)/1.5,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColors.color9747FF,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message,
                        style: TextStyle(color: AppColors.white, fontSize: 12)),
                    Text(
                      AppServices()
                          .formatedDateAndTime(DateTime.parse(createdAt)),
                      style: TextStyle(
                        fontSize: 8,
                        color: AppColors.colorEFEFEF,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _eyeDoctorMessageUserWidget(
    BuildContext context, String message, String createdAt) {
  return Container(
    width: getWidth(context: context),
    margin: EdgeInsets.only(left: 50, bottom: 10, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            // width: getWidth(context: context)/1.5,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColors.color9747FF,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message,
                    style: TextStyle(color: AppColors.white, fontSize: 12)),
                Text(
                  AppServices().formatedDateAndTime(DateTime.parse(createdAt)),
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.colorEFEFEF,
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(5),
        SizedBox(
          height: 30,
          width: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Icon(
              Icons.person_pin_sharp,
              color: AppColors.color008541,
            ),
          ),
        ),
      ],
    ),
  );
}
