import 'package:eye_buddy/app/bloc/network_block/network_bloc.dart';
import 'package:eye_buddy/app/bloc/network_block/network_state.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result_bloc/test_result_tab_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result_bloc/test_results_tab_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/no_internet_connection_widget.dart';
import 'package:eye_buddy/app/views/test_results/widgets/app_test_result_screen.dart';
import 'package:eye_buddy/app/views/test_results/widgets/clinical_results_screen.dart';
import 'package:eye_buddy/app/views/test_results/widgets/test_results_tab_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestResultsScreen extends StatefulWidget {
  TestResultsScreen({super.key});

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  List<Widget> views = [
    const AppTestResultScreen(),
    const ClinicalResultScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<TestResultCubit>().getClinicalTestResultData();
    context.read<TestResultCubit>().getAppTestResultData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.test_results,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Builder(builder: (context) {
        var networkState = context.watch<NetworkBloc>().state;

        if (networkState is NetworkFailure) {
          return const NoInterConnectionWidget();
        } else if (networkState is NetworkSuccess) {
          return Column(
            children: [
              const TestResultTabWidget(),
              Expanded(
                child: BlocBuilder<TestResultTabCubit, TestResultTabState>(
                  builder: (context, state) {
                    return PageView.builder(
                      itemCount: views.length,
                      controller: state.testResultTabPageController,
                      onPageChanged: (int value) {
                        switch (value) {
                          case 0:
                            if (state.testResultTabType != TestResultTabType.appTest) {
                              context.read<TestResultTabCubit>().updateAppointmentType(TestResultTabType.appTest);
                            }
                            break;
                          case 1:
                            if (state.testResultTabType != TestResultTabType.clinicalResult) {
                              context.read<TestResultTabCubit>().updateAppointmentType(TestResultTabType.clinicalResult);
                            }
                            break;
                        }
                      },
                      itemBuilder: (context, index) {
                        return views[index];
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
