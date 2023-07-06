
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';

import '../../blocs/appState/appState_cubit.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer, required this.url});
  final AudioPlayer audioPlayer;
  final String url;
  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<AppStateCubit>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      
        
         IconButton(
          onPressed: onUndo,
          icon: SvgPicture.asset(
            'assets/icons/undo.svg',
            color: themeCubit.theme == 'light' ? Colors.black : Colors.white,
            height: 25,
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: themeCubit.theme == 'light' ? Colors.black : Colors.white,
          child: StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  
                  return IconButton(
                      onPressed: audioPlayer.play,
                      iconSize: 40,
                      color: themeCubit.theme == 'light'
                          ? Colors.white
                          : Colors.black,
                      icon: const Icon(Icons.play_arrow_rounded));
                } else if (processingState != ProcessingState.completed) {
                  print(processingState);
                  return IconButton(
                      onPressed: audioPlayer.pause,
                      iconSize: 40,
                        color: themeCubit.theme == 'light'
                          ? Colors.white
                          : Colors.black,
                      icon: const Icon(Icons.pause_rounded));
                      
                }
                return IconButton(
                    onPressed: (){
                      audioPlayer.setUrl(url);
                      audioPlayer.play();
                    },
                    iconSize: 40,
                      color: themeCubit.theme == 'light'
                        ? Colors.white
                        : Colors.black,
                    icon: const Icon(Icons.play_arrow_rounded));
              }),
        ),
        IconButton(
          onPressed: onRedo,
          icon: SvgPicture.asset(
            'assets/icons/redo.svg',
            color: themeCubit.theme == 'light' ? Colors.black : Colors.white,
            height: 25,
          ),
        ),
      ],
    );
  }
  onRedo() async {
    var time = audioPlayer.position;
    int seconds = time.inSeconds + 30;
    if(seconds > audioPlayer.duration!.inSeconds) {
      seconds = audioPlayer.duration!.inSeconds;
    }
    await audioPlayer.seek(Duration(seconds: seconds));
  }

  onUndo() async  {
    var time = audioPlayer.position;
    int seconds = time.inSeconds - 15;
    if(seconds < 0) seconds = 0;
    await audioPlayer.seek(Duration(seconds: seconds));
  }
}

