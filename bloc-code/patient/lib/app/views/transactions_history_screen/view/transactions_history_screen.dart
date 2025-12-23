import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/transactions_history/transactions_history_cubit.dart';
import 'package:eye_buddy/app/bloc/transactions_history/transactions_history_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/transactions_history_screen/widget/transactions_list_item.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shemmer/card_skelton_screen.dart';

class TransactionsHistoryScreen extends StatelessWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsHistoryCubit(),
      child: _TransactionsHistoryScreen(),
    );
  }
}

class _TransactionsHistoryScreen extends StatefulWidget {
  const _TransactionsHistoryScreen();

  @override
  State<_TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState
    extends State<_TransactionsHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<TransactionsHistoryCubit>().getTransactionsHistory(
        context.read<PrescriptionListCubit>().state.patient.id!);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.transactions_history,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocConsumer<TransactionsHistoryCubit, TransactionsHistoryState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state.isLoading
              ? Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  // child: CustomLoader(),
                  child: NewsCardSkelton(),
                )
              : state.getAppointmentApiResponse!.appointmentList!
                      .appointmentData!.isEmpty
                  ? NoDataFoundWidget(
                      title: "You don't have any transactions history",
                    )
                  : RefreshIndicator(
                      onRefresh: () => context
                          .read<TransactionsHistoryCubit>()
                          .getTransactionsHistory(context
                              .read<PrescriptionListCubit>()
                              .state
                              .patient
                              .id!),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: SizedBox(
                          child: ListView.builder(
                            itemCount: state.getAppointmentApiResponse!
                                .appointmentList!.appointmentData!.length,
                            // controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 50, top: 17),
                            // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // 3
                              return TransactionsListItem(
                                appointmentData: state
                                    .getAppointmentApiResponse!
                                    .appointmentList!
                                    .appointmentData![index],
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
