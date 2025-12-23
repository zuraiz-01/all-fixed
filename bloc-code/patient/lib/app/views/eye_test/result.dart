import 'dart:developer';

import 'package:eye_buddy/app/bloc/app_eye_test_cubit/app_eye_test_cubit.dart';
import 'package:eye_buddy/app/views/eye_test/resultpage/bad.dart';
import 'package:eye_buddy/app/views/eye_test/resultpage/ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/model/app_test_result_response_model.dart';
import '../../bloc/profile/profile_cubit.dart';
import '../../bloc/test_result/test_result_cubit.dart';
import 'resultpage/good.dart';

class EyeTestResult extends StatefulWidget {
  int id; //1 =Visual_Acuity_Test,  2 = Astigmatism_Test, 3 = Light_Sensitivity_Test,
  int counter; //LeftEye
  int counter2; //RightEye
  EyeTestResult(
      {required this.id, required this.counter, required this.counter2});

  @override
  _EyeTestResultState createState() =>
      _EyeTestResultState(id: id, counter: counter, counter2: counter2);
}

class _EyeTestResultState extends State<EyeTestResult> {
  int id;
  int counter;
  int counter2;

  _EyeTestResultState(
      {required this.id, required this.counter, required this.counter2});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var resultValue = [
      {
        "dateTime": DateTime.now().toString(),
        "leftEyeResult": counter,
        "rightEyeResult": counter2
      }
    ];

    log("test result $resultValue");

    String patientId =
        context.read<ProfileCubit>().state.profileResponseModel?.profile?.sId ??
            "";

    Map<String, dynamic> parameters = Map<String, dynamic>();

    String leftEyeResultForAmdAndColorVision = "";
    String rightEyeResultForAmdAndColorVision = "";

    print("Counter1: $counter");
    print("Counter2: $counter2");

    if (counter + counter2 >= 10) {
      leftEyeResultForAmdAndColorVision = "Normal";
      rightEyeResultForAmdAndColorVision = "Normal";
    } else {
      if (counter + counter2 >= 1 && counter + counter2 >= 9) {
        leftEyeResultForAmdAndColorVision = "Normal";
        rightEyeResultForAmdAndColorVision = "Normal";
      } else {
        leftEyeResultForAmdAndColorVision = "Abnormal";
        rightEyeResultForAmdAndColorVision = "Abnormal";
      }
    }
    counter + counter2 >= 10
        ? GoodResult(id: id)
        : counter + counter2 >= 1 || 9 <= counter + counter2
            ? OK(id: id)
            : Bad(id: id);

    AppTestResultResponseModel? appTestResult =
        context.read<TestResultCubit>().state.appTestResult;

    if (id == 2) {
      //Near Vision Test
      parameters = {
        "patient": "$patientId",
        "data": {
          "nearVision": {
            "left": {"os": "$counter/23"},
            "right": {"od": "$counter2/23"}
          },
          "amdVision": {
            "left":
                "${appTestResult!.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.left}" : "--"}",
            "right":
                "${appTestResult.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.right}" : "--"}"
          },
          "colorVision": {
            "left":
                "${appTestResult.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.left}" : "--"}",
            "right":
                "${appTestResult.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.right}" : "--"}"
          },
          "visualAcuity": {
            "left": {
              "os":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.left!.os}" : "--"}",
            },
            "right": {
              "od":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.right!.od}" : "--"}",
            }
          },
        }
      };
      // if (appTestResult!.appTestData!.amdVision != null) {
      //   parameters["data"]["colorVision"] = {"left": "${appTestResult!.appTestData!.colorVision!.left}", "right": "${appTestResult!.appTestData!.colorVision!.right}"};
      // }
      // if (appTestResult!.appTestData!.amdVision != null) {
      //   parameters["data"]["amdVision"] = {"left": "${appTestResult!.appTestData!.amdVision!.left}", "right": "${appTestResult!.appTestData!.amdVision!.right}"};
      // }
    } else if (id == 3) {
      //Color Blind Test
      parameters = {
        "patient": "$patientId",
        "data": {
          "colorVision": {
            "left": "$leftEyeResultForAmdAndColorVision",
            "right": "$rightEyeResultForAmdAndColorVision"
          },
          "amdVision": {
            "left":
                "${appTestResult!.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.left}" : "--"}",
            "right":
                "${appTestResult.appTestData!.amdVision != null ? "${appTestResult.appTestData!.amdVision!.right}" : "--"}"
          },
          "nearVision": {
            "left": {
              "os":
                  "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.left!.os}" : "--"}"
            },
            "right": {
              "od":
                  "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.right!.od}" : "--"}"
            }
          },
          "visualAcuity": {
            "left": {
              "os":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.left!.os}" : "--"}",
            },
            "right": {
              "od":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.right!.od}" : "--"}",
            }
          },
        }
      };
    } else if (id == 4) {
      //AMD Test
      parameters = {
        "patient": "$patientId",
        "data": {
          "amdVision": {
            "left": "$leftEyeResultForAmdAndColorVision",
            "right": "$rightEyeResultForAmdAndColorVision"
          },
          "colorVision": {
            "left":
                "${appTestResult!.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.left}" : "--"}",
            "right":
                "${appTestResult.appTestData!.colorVision != null ? "${appTestResult.appTestData!.colorVision!.right}" : "--"}"
          },
          "nearVision": {
            "left": {
              "os":
                  "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.left!.os}" : "--"}"
            },
            "right": {
              "od":
                  "${appTestResult.appTestData!.nearVision != null ? "${appTestResult.appTestData!.nearVision!.right!.od}" : "--"}"
            }
          },
          "visualAcuity": {
            "left": {
              "os":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.left!.os}" : "--"}",
            },
            "right": {
              "od":
                  "${appTestResult.appTestData!.visualAcuity != null ? "${appTestResult.appTestData!.visualAcuity!.right!.od}" : "--"}",
            }
          },
        }
      };
    }

    log("eye test parameters ${parameters}");

    context
        .read<AppEyeTestCubit>()
        .updateAppEyeTestTestResult(context, patientId, parameters);

    context.read<TestResultCubit>().getAppTestResultData();
    // try {
    //   var userId = FirebaseAuth.instance.currentUser!.uid;
    //
    //   String testType = testModels[id - 1].title.replaceAll(" ", "");
    //   print(id);
    //   print(testType);
    //
    //   FirebaseFirestore.instance.collection("EyeTestResult").doc().set({
    //     "dateTime": DateTime.now(),
    //     "leftEyeResult": counter,
    //     "rightEyeResult": counter2,
    //     "testType": testType,
    //     "userID": userId
    //   });
    // } catch (e) {}

    // try {
    //   var userId = FirebaseAuth.instance.currentUser.uid;

    //   String testType = testModels[id - 1].title.replaceAll(" ", "");
    //   print(id);
    //   print(testType);

    //   FirebaseFirestore.instance
    //       .collection(testType)
    //       .doc(userId)
    //       .get()
    //       .then((value) {
    //     if (value.data() == null) {
    //       FirebaseFirestore.instance
    //           .collection(testType)
    //           .doc(userId)
    //           .set({"EyeResult": resultValue}).then((value) {
    //         print("---------------- User ID & Result Added");
    //         resultValue = null;
    //       });
    //     } else {
    //       FirebaseFirestore.instance.collection(testType).doc(userId).update(
    //           {"EyeResult": FieldValue.arrayUnion(resultValue)}).then((value) {
    //         print("---------------- Result updated");
    //         resultValue = null;
    //       });
    //     }
    //   });
    // } catch (e) {}

    // FirebaseFirestore.instance
    //     .collection("AstigmatismTest")
    //     .doc(userId)
    //     .get()
    //     .then((dateValue) async {
    //   print("yes, found");
    //   print(dateValue.data()["EyeResult"][0]["dateTime"]);
    //   await dateValue.data().forEach((key, value) {
    //     print(key);
    //     print(value[0]["dateTime"]);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    log("id $id");
    log("counter $counter");
    log("counter2 $counter2");

    return counter + counter2 >= 10
        ? GoodResult(id: id)
        : counter + counter2 >= 1 || 9 <= counter + counter2
            ? OK(id: id)
            : Bad(id: id);
  }
}
