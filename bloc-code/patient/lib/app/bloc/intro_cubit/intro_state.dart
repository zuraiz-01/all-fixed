// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'intro_cubit.dart';

abstract class IntroState extends Equatable {
  int currentPageIndex;
  IntroState({
    required this.currentPageIndex,
  });
  @override
  List<Object> get props => [
        currentPageIndex,
      ];
}

class IntroIdle extends IntroState {
  IntroIdle({
    required super.currentPageIndex,
  });
}
