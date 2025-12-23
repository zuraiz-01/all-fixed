// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'agora_call_state.dart';

// class AgoraCallCubit extends Cubit<AgoraCallState> {
//   AgoraCallCubit()
//       : super(
//           AgoraCallState(
//             isLocalMicActive: true,
//             isLocalVideoActive: true,
//             isRemoteAudioActive: true,
//             appId: "0fb1a1ecf5a34db2b51d9896c994652a",
//             channelId: "",
//             patientToken: "",
//             isLoading: false,
//           ),
//         );

//   void toogleRemoteAudio({required bool isActive}) {
//     emit(
//       state.copyWith(
//         isRemoteAudioActive: isActive,
//       ),
//     );
//   }

//   void toogleLocalMic({required bool isActive}) {
//     emit(
//       state.copyWith(
//         isLocalMicActive: isActive,
//       ),
//     );
//   }

//   void emitLoading({required bool isLoading}) {
//     emit(
//       state.copyWith(
//         isLoading: isLoading,
//       ),
//     );
//   }

//   Future<void> setAgoraChannelID({
//     required String channelId,
//   }) async {
//     emit(
//       state.copyWith(
//         channelId: channelId,
//       ),
//     );
//   }

//   void setAgoraToken({
//     required String token,
//   }) {
//     emit(
//       state.copyWith(
//         patientToken: token,
//       ),
//     );
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'agora_call_state.dart';

class AgoraCallCubit extends Cubit<AgoraCallState> {
  AgoraCallCubit()
      : super(
          const AgoraCallState(
            isLocalMicActive: true,
            isLocalVideoActive: true,
            isRemoteAudioActive: true,
            appId: "0fb1a1ecf5a34db2b51d9896c994652a",
            channelId: "",
            patientToken: "",
            isLoading: false,
          ),
        );

  /// Toggle local mic
  void toggleLocalMic({required bool isActive}) {
    emit(state.copyWith(isLocalMicActive: isActive));
  }

  /// Toggle remote audio
  void toggleRemoteAudio({required bool isActive}) {
    emit(state.copyWith(isRemoteAudioActive: isActive));
  }

  /// Toggle local video
  void toggleLocalVideo({required bool isActive}) {
    emit(state.copyWith(isLocalVideoActive: isActive));
  }

  /// Set loading state
  void emitLoading({required bool isLoading}) {
    emit(state.copyWith(isLoading: isLoading));
  }

  /// Set Agora channel ID
  Future<void> setAgoraChannelID({required String channelId}) async {
    emit(state.copyWith(channelId: channelId));
  }

  /// Set Agora token for patient
  void setAgoraToken({required String token}) {
    emit(state.copyWith(patientToken: token));
  }

  /// Set remote UID when patient joins
  void setRemoteUid(int uid) {
    emit(state.copyWith(remoteUid: uid));
  }

  /// Reset remote UID when patient leaves
  void resetRemoteUid() {
    emit(state.copyWith(remoteUid: null));
  }
}
