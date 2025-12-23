// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'agora_call_events_cubit.dart';

class AgoraCallEventsState extends Equatable {
  bool isLoading;
  bool hasPatientJoinedTheCall;
  AgoraCallEventsState({
    required this.isLoading,
    required this.hasPatientJoinedTheCall,
  });

  @override
  List<Object> get props => [
        isLoading,
        hasPatientJoinedTheCall,
      ];
}

class AgoraCallJoinedEvent extends AgoraCallEventsState {
  AgoraCallJoinedEvent({
    required super.isLoading,
    required super.hasPatientJoinedTheCall,
  });
}

class AgoraCallRejectedEvent extends AgoraCallEventsState {
  AgoraCallRejectedEvent({
    required super.isLoading,
    required super.hasPatientJoinedTheCall,
  });
}

class AgoraCallEndedEvent extends AgoraCallEventsState {
  AgoraCallEndedEvent({
    required super.isLoading,
    required super.hasPatientJoinedTheCall,
  });
}
