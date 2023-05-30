// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'voice_bloc.dart';

abstract class VoiceState extends Equatable {
  const VoiceState();

  @override
  List<Object> get props => [];
}

class VoiceInitial extends VoiceState {}

class VoiceLoaded extends VoiceState {
  final List<Voice> listVoices;
  final List<ItemRecord> listItems;
  const VoiceLoaded({
    required this.listVoices,
    required this.listItems,
  });

  @override
  List<Object> get props => [listVoices , listItems];
}
