// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

import 'package:listify/blocs/voice/voice_bloc.dart';
import 'package:listify/models/item_record.dart';
import 'package:listify/models/voice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/position_data.dart';
import '../../models/task.dart';
import 'control.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key, required this.task});
  final MyTask task;

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  final recorder = FlutterSoundRecorder();
  Stream<PositionData> get positionDataSteam =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition));

  int indexExpand = -1;
  bool isReadyRecord = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    audioPlayer.setLoopMode(LoopMode.off);
    context.read<VoiceBloc>().add(VoiceLoadByTask(task: widget.task));
    initRecorder();
  }
  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All records'),
      ),
      body: recordList(),
    );
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw ('microphone request failed');
    }
    await recorder.openRecorder();
    isReadyRecord = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future stop() async {
    if (!isReadyRecord) return;
    final path = await recorder.stopRecorder();
    var stringFile = '';
    print(path);
    var now = DateTime.now().millisecondsSinceEpoch;
    Reference ref = FirebaseStorage.instance.ref().child('/voices/$now');
    UploadTask uploadTask =
        ref.putFile(File(path!), SettableMetadata(contentType: 'audio/wav'));
    await uploadTask.then((res) async {
      stringFile = await res.ref.getDownloadURL();
    });
    final newVoice = Voice(
        id: now,
        taskId: widget.task.id,
        name: now.toString(),
        file: stringFile);
    context
        .read<VoiceBloc>()
        .add(VoiceCreate(voice: newVoice, task: widget.task));
  }

  Future record() async {
    if (!isReadyRecord) return;
    await recorder.startRecorder(
      toFile: 'audio.aac',
    );
  }

  recordAction() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.grey[300],
      height: recorder.isRecording ? 120 : 70,
      child: SingleChildScrollView(
        padding:  EdgeInsets.only(top:  recorder.isRecording ?  15 : 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recorder.isRecording
                  ? StreamBuilder<RecordingDisposition>(
                      stream: recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final twoDigitMinutes =
                            twoDigits(duration.inMinutes.remainder(60));
                        final twoDigitSeconds =
                            twoDigits(duration.inSeconds.remainder(60));
                        return Text(
                          '$twoDigitMinutes:$twoDigitSeconds',
                          style: const TextStyle(fontSize: 15),
                        );
                      })
                  : Container(),
              IconButton(
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      if (indexExpand != -1) {
                        context.read<VoiceBloc>().add(ExpansionPanelTappedEvent(
                            index: indexExpand, isExpanded: false));
                      }
                      await record();
                    }
                    setState(() {});
                  },
                  icon: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 25,
                      child: Icon(
                        recorder.isRecording ? Icons.stop : Icons.mic,
                        size: 40,
                        color: Colors.white,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  recordList() {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
            height: size.height * 0.7,
            left: 0,
            right: 0,
            top: 0,
            child: SingleChildScrollView(child: recordBody())),
        Positioned(
          child: recordAction(),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ],
    );
  }

  recordBody() {
    return BlocBuilder<VoiceBloc, VoiceState>(
      builder: (context, state) {
        if (state is VoiceLoaded) {
          return state.listItems.isNotEmpty
              ? ExpansionPanelList(
                  expansionCallback: (index, isExpanded) async {
                    context.read<VoiceBloc>().add(ExpansionPanelTappedEvent(
                        index: index, isExpanded: !isExpanded));
                    await audioPlayer.setUrl(state.listItems[index].voice.file);
                    indexExpand = index;
                  },
                  children: state.listItems.map<ExpansionPanel>((e) {
                    return ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(e.voice.name),
                            subtitle: durationWidget(e.voice.file),
                          );
                        },
                        isExpanded: e.isExpanded,
                        body: createPlayer(e));
                  }).toList(),
                )
              : emptyWidget();
        } else {
          return Container();
        }
      },
    );
  }

  Future<String> getDurationFromMp3(String url) async {
    try {
      final player = AudioPlayer();
      var duration = await player.setUrl(url);

      String durationString = duration.toString().split('.').first;

      return durationString;
    } catch (ex) {
      return '00:00';
    }
  }

  Widget durationWidget(String file) {
    return FutureBuilder<String>(
      future: getDurationFromMp3(file),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('00:00');
        } else if (snapshot.hasData) {
          return Text(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else {
          return const Text('Không có dữ liệu');
        }
      },
    );
  }

  createPlayer(ItemRecord item) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<PositionData>(
                stream: positionDataSteam,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.grey[300],
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.grey,
                    thumbColor: Colors.grey,
                    timeLabelTextStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: audioPlayer.seek,
                  );
                }),
          ),
          Row(
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () async {
                        await showEditDialog(context, item);
                      },
                      icon: const Icon(Icons.edit))),
              Expanded(
                  flex: 3,
                  child:
                      Controls(audioPlayer: audioPlayer, url: item.voice.file)),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        context
                            .read<VoiceBloc>()
                            .add(VoiceDelete(voice: item.voice));
                      },
                      icon: const Icon(Icons.delete_forever_rounded)))
            ],
          ),
        ],
      ),
    );
  }

  Future showEditDialog(context, ItemRecord item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final editNameController = TextEditingController(text: item.voice.name);
        return StatefulBuilder(builder: (context, updateState) {
          return AlertDialog(
            title: const Text('Edit Name Record'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                  autofocus: true,
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Invalid value';
                  },
                  onChanged: (value) {
                    updateState(() {});
                    print(editNameController.text);
                  },
                  controller: editNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: item.voice.name == editNameController.text
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();

                          final updateVoices = item.copyWith(
                              voice: item.voice
                                  .copyWith(name: editNameController.text));
                          print(updateVoices.voice.name);
                          context
                              .read<VoiceBloc>()
                              .add(VoiceUpdate(voice: updateVoices.voice));
                        }
                      },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }
  
  emptyWidget() {
    return Center(
      child: Column(

        children:  [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
        const Icon(Icons.mic_off_sharp , size: 100,),
        const Text('No records found')
      ]),
    );
  }
}
