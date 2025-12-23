// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homeframe_cubit.dart';

abstract class HomeframeState extends Equatable {
  int currentPageIndex;
  HomeframeState({
    required this.currentPageIndex,
  });

  @override
  List<Object> get props => [
        currentPageIndex,
      ];
}

class HomeframeIdle extends HomeframeState {
  HomeframeIdle({
    required super.currentPageIndex,
  });
}
