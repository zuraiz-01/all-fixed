import 'package:eye_buddy/app/bloc/medication_tracker_cubit/medication_tracker_cubit.dart';
import 'package:eye_buddy/app/bloc/network_block/network_bloc.dart';
import 'package:eye_buddy/app/bloc/network_block/network_state.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/no_internet_connection_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/medication_tracker/add_medication_screen.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_tracker_tile_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global_widgets/custom_loader.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen();

  @override
  State<MedicationTrackerScreen> createState() => _MedicationTrackerViewState();
}

class _MedicationTrackerViewState extends State<MedicationTrackerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(context)!;
    SizeConfig().init(context);
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
          title: localLanguage.medication_tracker,
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<MedicationTrackerCubit, MedicationTrackerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              bottom: getProportionateScreenWidth(20),
            ),
            child: CustomButton(
              title: 'Create New Medication',
              callBackFunction: () {
                NavigatorServices().to(
                  context: context,
                  widget: AddOrEditMedicationScreen(),
                );
              },
            ),
          );
        },
      ),
      body: Builder(builder: (context) {
        var networkState = context.watch<NetworkBloc>().state;
        if (networkState is NetworkFailure) {
          return const NoInterConnectionWidget();
        } else if (networkState is NetworkSuccess) {
          return BlocConsumer<MedicationTrackerCubit, MedicationTrackerState>(
            listener: (context, state) {
              if (state is MedicationTrackerFailed) {
                showToast(
                  message: state.errorMessage,
                  context: context,
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  child: const CustomLoader(),
                );
              }
              if (state is MedicationTrackerSuccess && !state.isLoading) {
                if (state.medicationTrackerData?.docs?.length == 0) {
                  return NoDataFoundWidget(
                    title: "You don't have any medication tracking history",
                  );
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemCount: state.medicationTrackerData?.docs?.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MedicationTrackerTileWidget(
                              isActive: state.medicationTrackerData!
                                      .docs![index].status ==
                                  "active",
                              medication:
                                  state.medicationTrackerData!.docs![index],
                            );
                          },
                        ),
                        const SizedBox(
                          height: kTextTabBarHeight * 3,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
