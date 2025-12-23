// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/doctor_tile.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/patient_tile.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/payment_gateway/view/payment_gateway_view.dart';
import 'package:eye_buddy/app/views/promos_screen/views/promos_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../api/model/doctor_list_response_model.dart' as docListDoc;
import '../../../api/model/patient_list_model.dart';
import '../../../bloc/appointment_cubit/appointment_cubit.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/keys/shared_pref_keys.dart';
import '../../global_widgets/toast.dart';
import '../../shemmer/card_skelton_screen.dart';
import '../../waiting_for_doctor/view/waiting_for_doctor_screen.dart';

class CreateAppointmentOverviewScreen extends StatefulWidget {
  CreateAppointmentOverviewScreen({
    super.key,
    required this.patientData,
    required this.selectedDoctor,
    required this.appointment,
  });

  MyPatient patientData;
  docListDoc.Doctor selectedDoctor;
  Appointment appointment;

  @override
  State<CreateAppointmentOverviewScreen> createState() =>
      _CreateAppointmentOverviewScreenState();
}

class _CreateAppointmentOverviewScreenState
    extends State<CreateAppointmentOverviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appointmentId =
        context.read<ReasonForVisitCubit>().state.selectedAppointment?.id ??
            "NO-UD";
  }

  String? appointmentId;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
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
          title: 'Overview',
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
          builder: (context, state) {
            return CustomButton(
              title: l10n.proceedNext,
              callBackFunction: () async {
                // NavigatorServices().to(
                //   context: context,
                //   widget: const WaitingForDoctorScreen(),
                // );

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs
                    .setString(
                      agoraChannelId,
                      state.selectedAppointment?.id ?? "",
                    )
                    .toString();
                prefs
                    .setString(
                      agoraDocName,
                      widget.selectedDoctor.name ?? "",
                    )
                    .toString();
                prefs
                    .setString(
                      agoraDocPhoto,
                      widget.selectedDoctor.photo ?? "",
                    )
                    .toString();
                context.read<ReasonForVisitCubit>().inititatePayment({
                  "appointment": appointmentId,
                  "paymentGateway": "sslcommerz"
                  // "paymentId": "abc123abc",
                  // "paymentMethod": "BKash",
                });
              },
            );
          },
        ),
      ),
      body: BlocListener<ReasonForVisitCubit, ReasonForVisitState>(
        listener: (context, state) {
          if (state is ReasonForVisitSuccessState) {
            print("Gateway: " + state.gatewayUrl);

            if (state.gatewayUrl.isNotEmpty) {
              NavigatorServices().toReplacement(
                context: context,
                widget: PaymentGatewayView(
                  url: state.gatewayUrl,
                  patientData: widget.patientData,
                  selectedDoctor: widget.selectedDoctor,
                ),
              );
            } else {
              showToast(
                message:
                    "An error occured while opening payment gateway! Please try again...",
                context: context,
              );
            }
          } else if (state is ReasonForVisitErrorState) {
            context.read<ReasonForVisitCubit>().resetState();
            showToast(message: state.errorMessage, context: context);
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: getHeight(context: context),
              width: getWidth(context: context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      DoctorTile(
                        selectedDoctor: widget.selectedDoctor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PatientTile(
                        forOverviewScreen: true,
                        patientData: widget.patientData,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                        builder: (context, state) {
                          return _PaymentDetailsTile(
                            appointmentModel:
                                state.selectedAppointment ?? widget.appointment,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              log(state.selectedAppointment?.id ?? "NO ID");

                              Navigator.of(context)
                                  .push(
                                PageTransition(
                                  child: PromosScreen(
                                      appointmentId:
                                          state.selectedAppointment?.id ?? ""),
                                  type: PageTransitionType.fade,
                                  duration: const Duration(milliseconds: 100),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              width: getWidth(context: context),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: AppColors.colorEFEFEF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.promos,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InterText(
                                        title: 'Do you have any promo code?',
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: AppColors.color888E9D,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const _PaumentTile(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
              builder: (context, state) {
                return state.isLoading ? NewsCardSkelton() : SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _PaumentTile extends StatelessWidget {
  const _PaumentTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context: context),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.colorEFEFEF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterText(
            title: 'Pay with',
            fontSize: 12,
            textColor: AppColors.color888E9D,
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 61,
              width: getWidth(context: context),
              decoration: BoxDecoration(
                color: AppColors.colorEFEFEF,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppAssets.bkash,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: AppColors.color888E9D,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 61,
              width: getWidth(context: context),
              decoration: BoxDecoration(
                color: AppColors.colorEFEFEF,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppAssets.paymentGateways,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: AppColors.color888E9D,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailsTile extends StatelessWidget {
  Appointment appointmentModel;

  _PaymentDetailsTile({
    Key? key,
    required this.appointmentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context: context),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.colorEFEFEF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InterText(
                  title: 'Payment Details',
                  fontSize: 12,
                  textColor: AppColors.color888E9D,
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                  builder: (context, state) {
                    return _PaymentDetailsDataRow(
                      title: 'Consultation fee',
                      amount: "$getCurrencySymbol " +
                          (state.selectedAppointment?.totalAmount ?? 0)
                              .toString(),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                  builder: (context, state) {
                    log("Rebuilding");

                    return _PaymentDetailsDataRow(
                      title: 'Vat (5%)',
                      amount: "$getCurrencySymbol " +
                          (state.selectedAppointment?.vat ?? 0).toString(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                  (index) => const SizedBox(
                    width: 6,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.colorEFEFEF,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                  builder: (context, state) {
                    return _PaymentDetailsDataRow(
                      title: 'Total',
                      amount: "$getCurrencySymbol " +
                          (state.selectedAppointment?.grandTotal ?? 0)
                              .toString(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailsDataRow extends StatelessWidget {
  _PaymentDetailsDataRow({
    required this.title,
    required this.amount,
  });

  String title;
  String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InterText(
          title: title,
          fontSize: 14,
        ),
        InterText(
          title: amount,
          fontSize: 14,
        ),
      ],
    );
  }
}
