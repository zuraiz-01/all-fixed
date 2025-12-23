import 'package:carousel_slider/carousel_slider.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/home_banner_cubit/home_screen_banner_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSliderSection extends StatefulWidget {
  HomeSliderSection({
    super.key,
  });

  @override
  _HomeSliderSection createState() => _HomeSliderSection();
}

class _HomeSliderSection extends State<HomeSliderSection>
    with WidgetsBindingObserver {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBannerCubit, HomeScreenBannerState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: state.homeScreenBannerList!
                    .map(
                      (item) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            height: 184,
                            child: CommonNetworkImageWidget(
                              imageLink:
                                  '${ApiConstants.imageBaseUrl}${item.file}',
                            ),
                            // CommonNetworkImageWidget(imageLink: item),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  state.homeScreenBannerList!.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == entry.key
                          ? AppColors.primaryColor
                          : AppColors.colorCCE7D9,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
