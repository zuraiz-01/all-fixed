import 'package:eye_buddy/app/bloc/intro_cubit/intro_cubit.dart';
import 'package:eye_buddy/app/models/intro_widget_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroPageIndexer extends StatelessWidget {
  const IntroPageIndexer({
    super.key,
    required this.introPageImages,
  });

  final List<IntroWidgetModel> introPageImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: introPageImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Align(
                  child: BlocBuilder<IntroCubit, IntroState>(
                    builder: (context, state) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 5,
                        width: state.currentPageIndex == index ? 26 : 5,
                        decoration: BoxDecoration(
                          color: state.currentPageIndex == index ? AppColors.color008541 : AppColors.colorBBBBBB,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
