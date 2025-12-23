import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/bloc/favorites_doctor/favorites_doctor_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../api/model/doctor_list_response_model.dart';

class GetDoctorsProfile extends StatefulWidget {
  bool isFromFavoriteList;
  Doctor? doctor;

  GetDoctorsProfile({
    super.key,
    required this.isFromFavoriteList,
    required this.doctor,
  });

  @override
  State<GetDoctorsProfile> createState() => _GetDoctorsProfileState();
}

class _GetDoctorsProfileState extends State<GetDoctorsProfile> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileFilterState>(
      listener: (context, state) {
        if (state is AddDoctorToFavoritesDoctorSuccessful) {
          showToast(
            message: "Doctor added to favorite list",
            context: context,
          );
        } else if (state is RemoveDoctorFromFavoritesDoctorSuccessful) {
          showToast(
            message: "Doctor removed from favorite list",
            context: context,
          );
        }
      },
      builder: (context, state) {
        Doctor currentDoctor = state.doctor!;
        return Row(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenHeight(100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonNetworkImageWidget(
                  imageLink:
                      '${ApiConstants.imageBaseUrl}${widget.doctor!.photo}',
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InterText(
                    title: currentDoctor.name!,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InterText(
                              title: currentDoctor.specialty
                                  .map((e) => e.title)
                                  .toList()
                                  .join(", "),
                              fontSize: 12,
                              textColor: AppColors.color888E9D,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            InterText(
                              title: currentDoctor.hospital
                                  .map((e) => e.name)
                                  .toList()
                                  .join(", "),
                              fontSize: 12,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.doctor!.isFavorite!) {
                              context
                                  .read<FavoritesDoctorCubit>()
                                  .removeDoctorFromFavoritesDoctorList(
                                      widget.doctor!.id.toString(), -56);
                            } else {
                              context
                                  .read<FavoritesDoctorCubit>()
                                  .addDoctorToFavoritesDoctorList(
                                      widget.doctor!.id.toString());
                            }
                            setState(() {
                              widget.doctor!.isFavorite =
                                  !widget.doctor!.isFavorite!;
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                color: AppColors.color008541),
                            alignment: Alignment.center,
                            child: BlocBuilder<FavoritesDoctorCubit,
                                FavoritesDoctorState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.white),
                                    ),
                                  );
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.doctor?.isFavorite ?? false
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: InterText(
                                          fontSize: 14,
                                          textColor: AppColors.white,
                                          title:
                                              "${widget.doctor!.isFavorite ?? false ? "Remove from favorites" : 'Add to favourites'}",
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      IconButton(
                        onPressed: () {
                          Share.share(
                              'https://staging-api.eyebuddy.app/api/common/doctorPublicProfile/${(widget.doctor?.id ?? "").toString()}');
                        },
                        icon: Icon(
                          Icons.share_outlined,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // GetDoctorsProfileButton(
                      //   title: '',
                      //   icon: Icons.share_outlined,
                      //   isFilled: false,
                      //   fontSize: 10,
                      //   width: getProportionateScreenWidth(30),
                      //   callBackFunction: () {},
                      // ),

                      // GetDoctorsProfileButton(
                      //   title: 'Share',
                      //   icon: Icons.share_outlined,
                      //   isFilled: false,
                      //   fontSize: 10,
                      //   width: getProportionateScreenWidth(70),
                      //   callBackFunction: () {},
                      // ),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
