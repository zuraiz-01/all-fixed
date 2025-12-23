import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/model/notification_response_model.dart';
import '../../bloc/notification_cubit/notification_cubit.dart';
import '../../utils/config/app_colors.dart';
import '../../utils/functions.dart';
import '../../utils/size_config.dart';
import '../global_widgets/custom_loader.dart';
import '../global_widgets/inter_text.dart';
import '../global_widgets/no_data_found_widget.dart';
import '../shemmer/card_skelton_screen.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(),
      child: _NotificationsScreen(),
    );
  }
}

class _NotificationsScreen extends StatefulWidget {
  const _NotificationsScreen();

  @override
  State<_NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<_NotificationsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<NotificationCubit>().getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationListState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: InterText(
              title: 'Notifications',
            ),
          ),
          body: state.isLoading
              ? Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  child: NewsCardSkelton(),
                  // child: CustomLoader(),
                )
              : state.notificationList!.isEmpty
                  ? NoDataFoundWidget(
                      title: "You don't have any notification",
                    )
                  : Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      child: RefreshIndicator(
                        onRefresh: context.read<NotificationCubit>().refreshScreen,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: state.notificationList!.length,
                          itemBuilder: (context, index) {
                            return notificationItem(state.notificationList![index]);
                          },
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget notificationItem(NotificationModel notificationModel) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      // color: AppColors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(color: AppColors.colorCCE7D9, borderRadius: BorderRadius.circular(40)),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.primaryColor,
                      size: 18,
                    )),
                SizedBox(
                  width: getProportionateScreenHeight(10),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '${notificationModel.metaData!.description}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          children: <TextSpan>[
                            // TextSpan(
                            //   text: '${notificationModel.type}',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w600,
                            //     color: AppColors.primaryColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      InterText(
                        title: '${formatDateDDMMMMYYYY(notificationModel.metaData!.date!)}',
                        fontSize: 9,
                        textColor: AppColors.color888E9D,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.colorEDEDED,
          )
        ],
      ),
    );
  }
}
