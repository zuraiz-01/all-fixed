import 'package:eye_buddy/app/bloc/promo_bloc/promo_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/promos_screen/widgets/promos_list_item.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shemmer/card_skelton_screen.dart';

class PromosScreen extends StatelessWidget {
  PromosScreen({
    super.key,
    this.appointmentId = null,
  });
  String? appointmentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoCubit(),
      child: _PromosScreen(
        appointmentId: appointmentId,
      ),
    );
  }
}

class _PromosScreen extends StatefulWidget {
  _PromosScreen({
    this.appointmentId = null,
  });
  String? appointmentId;

  @override
  State<_PromosScreen> createState() => _PromosScreenState();
}

class _PromosScreenState extends State<_PromosScreen> {
  TextEditingController promoCodeController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<PromoCubit>().getPromoList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: localLanguage.promos,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      bottomNavigationBar: BlocBuilder<PromoCubit, PromoState>(
        builder: (contextCubit, state) {
          return state.isLoading
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    bottom: getProportionateScreenWidth(20),
                  ),
                  child: CustomButton(
                    title: localLanguage.add_promo_code,
                    callBackFunction: () {
                      showModalBottomSheet(
                        context: context,
                        // color is applied to main screen when modal bottom screen is displayed
                        barrierColor: Colors.black.withOpacity(.3),
                        //background color for modal bottom screen
                        backgroundColor: Colors.white,
                        //elevates modal bottom screen
                        elevation: 10,
                        // gives rounded corner to modal bottom screen
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        builder: (BuildContext context) {
                          // UDE : SizedBox instead of Container for whitespaces
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 22,
                              right: 22,
                              top: 22,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SizedBox(
                              // height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InterText(
                                    title: localLanguage.add_promo_code,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(12),
                                  ),
                                  CustomTextFormField(
                                    textEditingController: promoCodeController,
                                    hint: localLanguage.promo_code,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          title: localLanguage.cancel,
                                          backGroundColor:
                                              AppColors.color888E9D,
                                          callBackFunction: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      CommonSizeBox(
                                        width: getProportionateScreenWidth(15),
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          title: localLanguage.add,
                                          callBackFunction: () {
                                            Map<String, String> parameters =
                                                Map<String, String>();
                                            parameters["code"] =
                                                "${promoCodeController.text}";
                                            parameters["appointment"] =
                                                widget.appointmentId.toString();
                                            contextCubit
                                                .read<PromoCubit>()
                                                .applyPromoCode(
                                                  parameters,
                                                  context,
                                                )
                                                .then((value) {
                                              NavigatorServices()
                                                  .pop(context: context);
                                              NavigatorServices()
                                                  .pop(context: context);
                                              setState(() {});
                                            });
                                            ;
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
        },
      ),
      body: BlocConsumer<PromoCubit, PromoState>(
        listener: (context, state) {
          if (state is ApplyPromoSuccessful) {
            showToast(message: state.toastMessage, context: context);
            context.read<PromoCubit>().resetState();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: context.read<PromoCubit>().refreshData,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: state.isLoading
                  ? Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.white,
                      child: const NewsCardSkelton(),
                      // child: const CustomLoader(),
                    )
                  : state.promoResponseModel!.promoList!.isEmpty
                      ? NoDataFoundWidget(
                          title: "You don't have any promo",
                        )
                      : SizedBox(
                          child: ListView.builder(
                            itemCount:
                                state.promoResponseModel!.promoList!.length,
                            // controller: _scrollController,
                            cacheExtent: 10,
                            padding: EdgeInsets.only(
                                bottom: getProportionateScreenHeight(50),
                                top: getProportionateScreenHeight(10)),
                            // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (listViewContext, index) {
                              // 3
                              return GestureDetector(
                                onTap: () {
                                  if (widget.appointmentId != null) {
                                    Map<String, String> parameters =
                                        Map<String, String>();
                                    parameters["code"] =
                                        "${state.promoResponseModel!.promoList![index].code}";
                                    parameters["appointment"] =
                                        widget.appointmentId!;
                                    context
                                        .read<PromoCubit>()
                                        .applyPromoCode(
                                          parameters,
                                          context,
                                        )
                                        .then((value) {
                                      NavigatorServices().pop(context: context);
                                      setState(() {});
                                    });
                                  }
                                },
                                child: PromosListItem(
                                  promo: state
                                      .promoResponseModel!.promoList![index],
                                ),
                              );
                            },
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
