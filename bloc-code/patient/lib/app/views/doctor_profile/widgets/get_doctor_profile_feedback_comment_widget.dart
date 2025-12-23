import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../api/model/get_doctor_rating_model.dart';
import '../../../api/service/api_constants.dart';
import '../../global_widgets/common_network_image_widget.dart';

class GetDoctorProfileFeedbackCommentWidget extends StatelessWidget {
  GetDoctorProfileFeedbackCommentWidget({
    super.key,
    required this.commentDocument,
  });
  Doc? commentDocument;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: getProportionateScreenHeight(35),
            width: getProportionateScreenHeight(35),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                getProportionateScreenHeight(35),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                35,
              ),
              child: CommonNetworkImageWidget(
                imageLink: '${ApiConstants.imageBaseUrl}${commentDocument?.patient?.photo ?? ""}',
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InterText(
                      title: commentDocument?.patient?.name ?? "",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    InterText(
                      title: timeago.format(commentDocument?.createdAt ?? DateTime.now()),
                      fontSize: 13,
                      textColor: AppColors.color888E9D,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                RatingBar.builder(
                  initialRating: commentDocument?.rating ?? 0,
                  itemSize: 14,
                  maxRating: 5,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: print,
                ),
                const SizedBox(
                  height: 6,
                ),
                InterText(
                  title: commentDocument?.review ?? "",
                  fontSize: 14,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
