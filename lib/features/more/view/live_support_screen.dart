import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/global_widgets/toast.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/app_localizations.dart';

class LiveSupportScreen extends StatefulWidget {
  const LiveSupportScreen({super.key});

  @override
  State<LiveSupportScreen> createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen> {
  late final TextEditingController _messageController;
  late final MoreController controller;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    // Ensure MoreController is available even when LiveSupportScreen
    // is opened from outside the MoreScreen tab.
    controller = Get.isRegistered<MoreController>()
        ? Get.find<MoreController>()
        : Get.put(MoreController());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: InterText(
          title: l10n.support,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textColor: AppColors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(16),
                    vertical: getProportionateScreenWidth(12),
                  ),
                  reverse: true,
                  itemCount: controller.chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = controller.chatMessages.reversed
                        .toList()[index];
                    return Align(
                      alignment: message.fromUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(12),
                          vertical: getProportionateScreenHeight(10),
                        ),
                        decoration: BoxDecoration(
                          color: message.fromUser
                              ? AppColors.primaryColor
                              : AppColors.colorCCE7D9,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InterText(
                              title: message.message,
                              fontSize: 14,
                              textColor: message.fromUser
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                            CommonSizeBox(
                              height: getProportionateScreenHeight(4),
                            ),
                            InterText(
                              title: _formatTime(message.sentAt),
                              fontSize: 10,
                              textColor: message.fromUser
                                  ? AppColors.colorEDEDED
                                  : AppColors.color888E9D,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _MessageComposer(
              controller: _messageController,
              onSend: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _handleSendMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (_messageController.text.trim().isEmpty) {
      showToast(message: l10n.type_a_message_to_continue, context: context);
      return;
    }
    controller.addChatMessage(_messageController.text.trim(), fromUser: true);
    _messageController.clear();
    // lightweight bot reply
    Future.delayed(const Duration(seconds: 1), () {
      controller.addChatMessage(l10n.thanks_for_reaching_out, fromUser: false);
    });
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(12),
        right: getProportionateScreenWidth(12),
        bottom: getProportionateScreenWidth(12),
        top: getProportionateScreenWidth(6),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.colorEDEDED, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: l10n.type_your_message,
                border: InputBorder.none,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
