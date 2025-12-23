import 'package:eye_buddy/app/bloc/doctor_list/doctor_list_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/widgets/doctor_list_item.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/widgets/doctor_search_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../shemmer/card_skelton_screen.dart';

class DoctorListScreen extends StatefulWidget {
  DoctorListScreen();

  @override
  State<DoctorListScreen> createState() => DoctorListScreenState();
}

class DoctorListScreenState extends State<DoctorListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DoctorListCubit doctorListCubit = context.read<DoctorListCubit>();
    if (doctorListCubit.state.doctorListResponseData!.doctorList!.isEmpty) {
      doctorListCubit.getSearchDoctorList({});
    }
    doctorListCubit.initScrollListener();
  }

  @override
  void didChangeDependencies() {
    // context.read<DoctorListCubit>().resetState();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // context.read<DoctorListCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: BlocBuilder<DoctorListCubit, DoctorListState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: context.read<DoctorListCubit>().refreshData,
            child: SizedBox(
              child: Column(
                children: [
                  DoctorSearchWidget(),
                  state.isLoading
                      ? Expanded(
                          child: const NewsCardSkelton(),
                          // child: const CustomLoader(),
                        )
                      : state.doctorListResponseData!.doctorList!.isEmpty
                          ? Expanded(
                              child: NoDataFoundWidget(
                                title: "You don't have any doctor",
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                controller: state.scrollController,
                                child: Column(
                                  children: [
                                    Gap(12),
                                    MediaQuery.removePadding(
                                      context: context,
                                      removeBottom: true,
                                      removeTop: true,
                                      child: ListView.builder(
                                        itemCount: state.doctorList!.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          // 3
                                          return DoctorListItem(
                                            doctor: state.doctorList![index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
