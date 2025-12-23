import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TestResultTabType {
  appTest,
  clinicalResult,
}

class TestResultTabState extends Equatable {
  TestResultTabState({
    required this.testResultTabType,
    required this.testResultTabPageController,
  });
  TestResultTabType testResultTabType;
  PageController testResultTabPageController;

  @override
  List<Object> get props => [
        testResultTabType,
        testResultTabPageController,
      ];

  TestResultTabState copyWith({
    TestResultTabType? testResultTabType,
    PageController? tabResultTabController,
  }) {
    return TestResultTabState(
      testResultTabType: testResultTabType ?? this.testResultTabType,
      testResultTabPageController: tabResultTabController ?? testResultTabPageController,
    );
  }
}
