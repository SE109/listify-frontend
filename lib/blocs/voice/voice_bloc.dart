import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listify/models/item_record.dart';
import 'package:listify/models/voice.dart';

import '../../models/task.dart';
import '../../repositories/voice_repository.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final voiceRepo = VoiceRepository.instance;
  VoiceBloc() : super(VoiceInitial()) {
    on<VoiceLoadByTask>(_onLoadVoiceByTask);
    on<ExpansionPanelTappedEvent>(_onExpansionPanelTappedEvent);
    on<VoiceCreate>(_onVoiceCreate);
    on<VoiceUpdate>(_onVoiceUpdate);
    on<VoiceDelete>(_onVoiceDelete);
  }

  FutureOr<void> _onLoadVoiceByTask(
      VoiceLoadByTask event, Emitter<VoiceState> emit) async {
    emit(VoiceInitial());
    var listVoices = await voiceRepo.getAllVoiceOfTask(event.task);
    var listItem = createListItem(listVoices);

    emit(VoiceLoaded(listVoices: listVoices, listItems: listItem));
  }

  FutureOr<void> _onExpansionPanelTappedEvent(
      ExpansionPanelTappedEvent event, Emitter<VoiceState> emit) async {
    if (state is VoiceLoaded) {
      var currentState = state as VoiceLoaded;
      final List<ItemRecord> updatedVoices = currentState.listItems
          .map((item) => item.copyWith(isExpanded: false))
          .toList();
      updatedVoices[event.index].isExpanded = event.isExpanded;
      emit(VoiceInitial());
      emit(VoiceLoaded(
          listVoices: currentState.listVoices, listItems: updatedVoices));
    }
  }

  List<ItemRecord> createListItem(List<Voice> listVoices) {
    var list = <ItemRecord>[];
    for (var item in listVoices) {
      list.add(ItemRecord(voice: item));
    }
    return list;
  }

  FutureOr<void> _onVoiceCreate(
      VoiceCreate event, Emitter<VoiceState> emit) async {
    if (state is VoiceLoaded) {
      var currentState = state as VoiceLoaded;
      final newVoice = await voiceRepo.createVoice(event.voice);
      var item = ItemRecord(voice: newVoice);
      emit(VoiceInitial());
      currentState.listVoices.add(newVoice);
      currentState.listItems.add(item);
      emit(VoiceLoaded(
          listVoices: currentState.listVoices,
          listItems: currentState.listItems));
    }
  }

  FutureOr<void> _onVoiceDelete(
      VoiceDelete event, Emitter<VoiceState> emit) async {
    if (state is VoiceLoaded) {
      var currentState = state as VoiceLoaded;
      await voiceRepo.deleteVoice(event.voice);
      emit(VoiceInitial());
      currentState.listItems
          .removeWhere((element) => element.voice.id == event.voice.id);
      currentState.listVoices
          .removeWhere((element) => element.id == event.voice.id);
      emit(VoiceLoaded(
          listVoices: currentState.listVoices,
          listItems: currentState.listItems));
    }
  }

  FutureOr<void> _onVoiceUpdate(
      VoiceUpdate event, Emitter<VoiceState> emit) async {
    if (state is VoiceLoaded) {
      var currentState = state as VoiceLoaded;
      await voiceRepo.updateVoice(event.voice);
      emit(VoiceInitial());
      final List<ItemRecord> updatedItems = currentState.listItems.map((item) {
        if (item.voice.id == event.voice.id) {
          return item.copyWith(
              voice: item.voice.copyWith(name: event.voice.name));
        }
        return item;
      }).toList();
      emit(VoiceLoaded(
          listVoices: currentState.listVoices, listItems: updatedItems));
    }
  }
}
