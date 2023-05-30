// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'voice_bloc.dart';

abstract class VoiceEvent extends Equatable {
  const VoiceEvent();

  @override
  List<Object> get props => [];
}

class VoiceLoadByTask extends VoiceEvent {
  final MyTask task;
  const VoiceLoadByTask({
    required this.task,
  });
  @override
  List<Object> get props => [task];
}

class ExpansionPanelTappedEvent extends VoiceEvent {
  final int index;
  final bool isExpanded;
  const ExpansionPanelTappedEvent({
    required this.index,
    required this.isExpanded
  });
  @override
  List<Object> get props => [index , isExpanded];
}

class VoiceCreate extends VoiceEvent {
  final Voice voice;
  final MyTask task;
  const VoiceCreate({
    required this.voice,
    required this.task,
  });
  @override
  List<Object> get props => [voice, task];
}

class VoiceUpdate extends VoiceEvent {
  final Voice voice;
  const VoiceUpdate({
    required this.voice,
  });
  @override
  List<Object> get props => [voice];
}

class VoiceDelete extends VoiceEvent {
  final Voice voice;
  const VoiceDelete({
    required this.voice,
  });
  @override
  List<Object> get props => [voice];
}

