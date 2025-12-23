// // ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'agora_call_cubit.dart';

// class AgoraCallState extends Equatable {
//   bool isLocalVideoActive;
//   bool isLocalMicActive;
//   bool isRemoteAudioActive;
//   String appId;
//   String channelId;
//   String patientToken;
//   bool? isLoading;

//   AgoraCallState({
//     required this.isLocalVideoActive,
//     required this.isLocalMicActive,
//     required this.isRemoteAudioActive,
//     required this.appId,
//     required this.channelId,
//     required this.patientToken,
//     this.isLoading = false,
//   });

//   @override
//   List<Object> get props => [
//         isLocalVideoActive,
//         isLocalMicActive,
//         isRemoteAudioActive,
//         appId,
//         channelId,
//         patientToken,
//         isLoading!,
//       ];

//   AgoraCallState copyWith({
//     bool? isLocalVideoActive,
//     bool? isLocalMicActive,
//     bool? isRemoteAudioActive,
//     String? appId,
//     String? channelId,
//     String? patientToken,
//     bool? isLoading,
//   }) {
//     return AgoraCallState(
//       isLocalVideoActive: isLocalVideoActive ?? this.isLocalVideoActive,
//       isLocalMicActive: isLocalMicActive ?? this.isLocalMicActive,
//       isRemoteAudioActive: isRemoteAudioActive ?? this.isRemoteAudioActive,
//       appId: appId ?? this.appId,
//       channelId: channelId ?? this.channelId,
//       patientToken: patientToken ?? this.patientToken,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }
part of 'agora_call_cubit.dart';

class AgoraCallState extends Equatable {
  final bool isLocalMicActive;
  final bool isLocalVideoActive;
  final bool isRemoteAudioActive;
  final bool isLoading;
  final String appId;
  final String channelId;
  final String patientToken;
  final int? remoteUid;

  const AgoraCallState({
    required this.isLocalMicActive,
    required this.isLocalVideoActive,
    required this.isRemoteAudioActive,
    required this.isLoading,
    required this.appId,
    required this.channelId,
    required this.patientToken,
    this.remoteUid,
  });

  AgoraCallState copyWith({
    bool? isLocalMicActive,
    bool? isLocalVideoActive,
    bool? isRemoteAudioActive,
    bool? isLoading,
    String? appId,
    String? channelId,
    String? patientToken,
    int? remoteUid,
  }) {
    return AgoraCallState(
      isLocalMicActive: isLocalMicActive ?? this.isLocalMicActive,
      isLocalVideoActive: isLocalVideoActive ?? this.isLocalVideoActive,
      isRemoteAudioActive: isRemoteAudioActive ?? this.isRemoteAudioActive,
      isLoading: isLoading ?? this.isLoading,
      appId: appId ?? this.appId,
      channelId: channelId ?? this.channelId,
      patientToken: patientToken ?? this.patientToken,
      remoteUid: remoteUid ?? this.remoteUid,
    );
  }

  @override
  List<Object?> get props => [
        isLocalMicActive,
        isLocalVideoActive,
        isRemoteAudioActive,
        isLoading,
        appId,
        channelId,
        patientToken,
        remoteUid,
      ];
}
