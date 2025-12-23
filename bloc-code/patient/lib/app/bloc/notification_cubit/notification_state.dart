part of 'notification_cubit.dart';

class NotificationListState extends Equatable {
  bool isLoading;
  NotificationResponseModel? notificationResponseModel;
  List<NotificationModel>? notificationList;

  NotificationListState({
    required this.isLoading,
    required this.notificationResponseModel,
    required this.notificationList,
  });

  @override
  List<Object> get props => [isLoading, notificationResponseModel.hashCode, notificationList!.length, notificationList.hashCode];

  NotificationListState copyWith({
    bool? isLoading,
    NotificationResponseModel? notificationResponseModel,
    List<NotificationModel>? notificationList,
  }) {
    return NotificationListState(
        isLoading: isLoading ?? this.isLoading,
        notificationResponseModel: notificationResponseModel ?? this.notificationResponseModel,
        notificationList: notificationList ?? this.notificationList);
  }
}

class NotificationListInitial extends NotificationListState {
  NotificationListInitial({required super.isLoading, required super.notificationResponseModel, required super.notificationList});
}

class NotificationListSuccessful extends NotificationListState {
  NotificationListSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.notificationResponseModel,
    required super.notificationList,
  });

  String toastMessage;
}

class NotificationListFailed extends NotificationListState {
  NotificationListFailed(
      {required super.isLoading,
      required this.errorMessage,
      required super.notificationResponseModel,
      required super.notificationList});

  String errorMessage;
}
