import 'package:eye_buddy/core/services/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/extensions.dart';
import 'package:eye_buddy/core/services/utils/functions.dart';
import 'package:eye_buddy/core/services/utils/global_variables.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/doctor_list/controller/doctor_profile_controller.dart';
import 'package:eye_buddy/features/doctor_list/widgets/get_doctor_statistics_tile.dart';
import 'package:eye_buddy/features/doctor_list/widgets/get_doctor_profile_bottom_bar.dart';
import 'package:eye_buddy/features/doctor_list/widgets/get_doctor_profile_filter.dart';
import 'package:eye_buddy/features/doctor_list/widgets/get_doctors_profile_widget.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api/service/api_constants.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    final controller = Get.put(
      DoctorProfileController(doctor: doctor, isFromFavoriteList: false),
    );

    return Obx(() {
      final currentDoctor = controller.selectedDoctor.value ?? doctor;

      return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Get.back(),
          ),
          title: InterText(title: l10n.profile),
          actions: [
            Align(
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primaryColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: InterText(
                  title: capitalizeFirstWord(
                    (currentDoctor.availabilityStatus ?? '').toString(),
                  ),
                  fontSize: 14,
                  textColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        bottomNavigationBar: GetDoctorProfileBottomBar(
          doctorProfile: currentDoctor,
        ),
        body: SizedBox(
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    GetDoctorsProfile(
                      isFromFavoriteList: false,
                      doctor: currentDoctor,
                    ),
                    SizedBox(height: getProportionateScreenHeight(24)),
                    GetDoctorsStatisticsTile(doctor: currentDoctor),
                    SizedBox(height: getProportionateScreenHeight(24)),
                    const DoctorProfileFilter(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Flexible(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: 3,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _DoctorProfileInfoTab(doctor: currentDoctor);
                    } else if (index == 1) {
                      return _DoctorProfileExperienceTab(doctor: currentDoctor);
                    }
                    return const _DoctorProfileFeedbackTab();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DoctorProfileInfoTab extends StatelessWidget {
  const _DoctorProfileInfoTab({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoWidget(
                    title: 'Consultation Fee',
                    subtitleOne: '',
                    subtitleTwo: '(Incl 5% vat)',
                    subtitleBuilder: FutureBuilder(
                      builder: (ctx, snapshot) {
                        return InterText(
                          title: '$getCurrencySymbol ${snapshot.data ?? ''}',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        );
                      },
                      initialData: '',
                      future: getDoctorConsultationFee(doctor: doctor),
                    ),
                  ),
                ),
                Expanded(
                  child: _InfoWidget(
                    title: 'Followup Fee',
                    subtitleOne: '',
                    subtitleTwo: '(Incl 5% vat)',
                    subtitleBuilder: FutureBuilder(
                      builder: (ctx, snapshot) {
                        return InterText(
                          title: '$getCurrencySymbol ${snapshot.data ?? ''}',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        );
                      },
                      initialData: '',
                      future: getDoctorFollowUpFeeUsd(doctor: doctor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _InfoWidget(
                    title: 'Average consultancy time',
                    subtitleOne: '${doctor.averageConsultancyTime ?? 0} min.',
                    subtitleTwo: '',
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            InterText(
              title: 'About Doctor',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textColor: AppColors.color008541,
            ),
            SizedBox(height: getProportionateScreenHeight(6)),
            InterText(title: doctor.about ?? '', fontSize: 14),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.title,
    required this.subtitleOne,
    required this.subtitleTwo,
    this.subtitleBuilder,
  });

  final String title;
  final String subtitleOne;
  final String subtitleTwo;
  final Widget? subtitleBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InterText(title: title, fontSize: 12, textColor: AppColors.color888E9D),
        const SizedBox(height: 6),
        Row(
          children: [
            subtitleBuilder ??
                InterText(
                  title: subtitleOne,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
            const SizedBox(width: 4),
            InterText(
              title: subtitleTwo,
              fontSize: 14,
              textColor: AppColors.color888E9D,
            ),
          ],
        ),
      ],
    );
  }
}

class _DoctorProfileExperienceTab extends StatelessWidget {
  const _DoctorProfileExperienceTab({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((doctor.experiences ?? []).isEmpty)
              SizedBox(
                height: SizeConfig.screenHeight / 3,
                child: Center(
                  child: InterText(title: "Don't have any experience"),
                ),
              ),
            ListView.builder(
              itemCount: doctor.experiences?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final exp = doctor.experiences![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InterText(
                          title: exp.designation ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        InterText(
                          title: exp.hospitalName ?? '',
                          fontSize: 12,
                          textColor: AppColors.color888E9D,
                        ),
                        const SizedBox(height: 4),
                        InterText(
                          title:
                              '${exp.startDate ?? ''} - ${exp.endDate ?? ''}',
                          fontSize: 12,
                          textColor: AppColors.color888E9D,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}

class _DoctorProfileFeedbackTab extends StatelessWidget {
  const _DoctorProfileFeedbackTab();

  Widget _buildStars(double rating) {
    final int fullStars = rating.floor().clamp(0, 5);
    final bool hasHalf = (rating - fullStars) >= 0.5 && fullStars < 5;
    final int emptyStars = 5 - fullStars - (hasHalf ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, size: 14, color: Colors.amber),
        if (hasHalf) const Icon(Icons.star_half, size: 14, color: Colors.amber),
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, size: 14, color: Colors.amber),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorProfileController>();

    return Obx(() {
      if (controller.isFeedbackLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.feedbackErrorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InterText(
                  title: controller.feedbackErrorMessage.value,
                  fontSize: 14,
                  textColor: AppColors.color888E9D,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.loadDoctorFeedback(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final docs = controller.feedbackModel.value?.data?.docs ?? const [];
      if (docs.isEmpty) {
        return Center(
          child: InterText(
            title: 'No feedback yet',
            fontSize: 14,
            textColor: AppColors.color888E9D,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: () => controller.loadDoctorFeedback(),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final rating = doc.rating ?? 0.0;
              final patientName = doc.patient?.name ?? 'Patient';
              final review = (doc.review ?? '').trim();
              final photoPath = doc.patient?.photo ?? '';
              final photoUrl = '${ApiConstants.imageBaseUrl}$photoPath';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: CommonNetworkImageWidget(imageLink: photoUrl),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InterText(
                                    title: patientName,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStars(rating),
                              ],
                            ),
                            if (review.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              InterText(title: review, fontSize: 14),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
