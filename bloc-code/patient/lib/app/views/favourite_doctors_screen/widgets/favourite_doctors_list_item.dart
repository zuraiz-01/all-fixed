import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/favorites_doctor/favorites_doctor_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteDoctorsListItem extends StatelessWidget {
  Doctor doctor;
  int index;
  FavouriteDoctorsListItem({
    required this.doctor,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: getWidth(context: context),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(90),
            width: getProportionateScreenHeight(90),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: CommonNetworkImageWidget(
                imageLink: '${ApiConstants.imageBaseUrl}${doctor.photo}',
              ),
            ),
          ),
          CommonSizeBox(
            width: getProportionateScreenWidth(14),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InterText(
                  title: '${doctor.name}',
                  textColor: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(6),
                ),
                InterText(
                  title:
                      '${doctor.specialty.map((e) => e.title).toList().join(", ")}',
                  fontSize: 12,
                  textColor: AppColors.color888E9D,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(4),
                ),
                InterText(
                  title:
                      '${doctor.hospital.map((e) => e.name).toList().join(", ")}',
                  fontSize: 12,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(14),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<FavoritesDoctorCubit>()
                              .removeDoctorFromFavoritesDoctorList(
                                  doctor.id.toString(), index);
                        },
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              CommonSizeBox(
                                width: getProportionateScreenWidth(6),
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: InterText(
                                    title: l10n.remove_from_favourites,
                                    fontSize: 14,
                                    maxLines: 1,
                                    textColor: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CommonSizeBox(
                      width: getProportionateScreenWidth(8),
                    ),
                    Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: InterText(
                        title: l10n.book_now,
                        fontSize: 14,
                        maxLines: 1,
                        textColor: AppColors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
