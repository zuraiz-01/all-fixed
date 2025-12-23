import 'package:eye_buddy/app/views/shemmer/skeleton.dart';
import 'package:flutter/material.dart';

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.white,
    //   child: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         ),
    //         const Skeleton(width: 80),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         const Skeleton(),
    //         const SizedBox(height: defaultPadding / 2),
    //         Row(
    //           children: const [
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //             SizedBox(width: defaultPadding),
    //             Expanded(
    //               child: Skeleton(),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
          SizedBox(width: 10),
          Text(
            "Loading...",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
