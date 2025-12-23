import 'package:flutter/material.dart';

import '../../utils/dimentions.dart';
import '../../utils/services/navigator_services.dart';
import '../global_widgets/common_app_bar.dart';
import '../global_widgets/custom_button.dart';
import '../global_widgets/inter_text.dart';
import '../rating_screen/rating_screen.dart';

class PrescriptionOverviewScreen extends StatelessWidget {
  PrescriptionOverviewScreen({
    super.key,
    required this.payload,
  });

  Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Overview",
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Container(
        height: getHeight(
          context: context,
        ),
        width: getWidth(
          context: context,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Material(
                elevation: 5,
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: getWidth(context: context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InterText(
                                    title: "Chief Complaints",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InterText(
                                    title: payload["note"] != null
                                        ? payload["note"].toString()
                                        : "",
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InterText(
                                    title: "Diagnosis",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InterText(
                                    title: payload["diagnosis"]
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InterText(
                                    title: "Investigations",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InterText(
                                    title: payload["investigations"]
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  InterText(
                                    title: "Surgery",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  InterText(
                                    title: payload["surgery"]
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: getWidth(context: context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InterText(
                                    title: "Medicine",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: ListView.builder(
                                      itemCount:
                                          (payload["medicines"] as List).length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InterText(
                                              title: (index + 1).toString() +
                                                  ". " +
                                                  (payload["medicines"]
                                                      as List)[index]["name"],
                                            ),
                                            InterText(
                                              title: "Notes: " +
                                                  (payload["medicines"]
                                                      as List)[index]["note"],
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InterText(
                        title: "Follow Up Date",
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      InterText(title: payload["followUpDate"]),
                      SizedBox(
                        height: 12,
                      ),
                      InterText(
                        title: "Reffered to",
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      InterText(
                        title: payload["referredTo"],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      title: "Exit",
                      callBackFunction: () {
                        NavigatorServices().pop(
                          context: context,
                        );
                      },
                      backGroundColor: Color(0xff888E9D),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      title: "Submit Rating",
                      callBackFunction: () {
                        NavigatorServices().to(
                          context: context,
                          widget: RatingScreen(
                            appointmentId: payload["id"] ?? "",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
