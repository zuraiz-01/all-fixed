import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'agora_call_events_state.dart';

class AgoraCallEventsCubit extends Cubit<AgoraCallEventsState> {
  AgoraCallEventsCubit()
      : super(
          AgoraCallEventsState(
            isLoading: false,
            hasPatientJoinedTheCall: false,
          ),
        );

  emitJoinedEvent() {
    emit(
      AgoraCallJoinedEvent(
        isLoading: state.isLoading,
        hasPatientJoinedTheCall: state.hasPatientJoinedTheCall,
      ),
    );
  }

  emitRejectedEvent() {
    emit(
      AgoraCallRejectedEvent(
        isLoading: state.isLoading,
        hasPatientJoinedTheCall: state.hasPatientJoinedTheCall,
      ),
    );
  }

  emitEndedEvent() {
    emit(
      AgoraCallEndedEvent(
        isLoading: state.isLoading,
        hasPatientJoinedTheCall: state.hasPatientJoinedTheCall,
      ),
    );
  }

  resetEvent() {
    emit(
      AgoraCallEventsState(
        isLoading: state.isLoading,
        hasPatientJoinedTheCall: false,
      ),
    );
  }
}
