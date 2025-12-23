import 'package:eye_buddy/app/bloc/intro_cubit/intro_cubit.dart';
import 'package:eye_buddy/app/models/intro_widget_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroBackgoundImageWidget extends StatelessWidget {
  IntroBackgoundImageWidget({
    required this.introPageImages,
    super.key,
  });

  List<IntroWidgetModel> introPageImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context: context),
      width: getWidth(context: context),
      child: PageView.builder(
        itemCount: introPageImages.length,
        onPageChanged: (value) {
          context.read<IntroCubit>().changePage(
                pageIndex: value,
              );
        },
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              // clipper: _CircularBottomOvalClipper(),
              child: Container(
                alignment: Alignment.bottomCenter,
                // color: AppColors.color008541,
                height: getHeight(context: context) / 1.33,
                width: getWidth(context: context)/1.2,
                child: Image.asset(
                  introPageImages[index].imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularBottomOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 70)
      ..quadraticBezierTo(
        size.width / 4,
        size.height,
        size.width / 2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width - size.width / 4,
        size.height,
        size.width,
        size.height - 70,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
