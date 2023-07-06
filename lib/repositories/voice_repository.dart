import 'package:listify/models/voice.dart';
import 'package:listify/repositories/user_repository.dart';

import '../models/task.dart';

class VoiceRepository {
  final dio = UserRepository.dio;
  VoiceRepository._privateConstructor();

  static final VoiceRepository _instance = VoiceRepository._privateConstructor();

  static VoiceRepository get instance => _instance;
  
  Future<List<Voice>> getAllVoiceOfTask(MyTask task) async{
    var response = await dio.get('/voice/vtask/${task.id}');

    List<Voice> voices =
        (response.data['data'] as List).map((e) => Voice.fromJson(e)).toList();

    return voices;
  }

  Future<Voice> createVoice(Voice voice) async {
    final response = await dio.post('/voice' , data: {
      "taskId": voice.taskId, 
      "name": voice.name, 
      "file": voice.file,
    });
  
   return  Voice.fromJson(response.data['data']);

  }

  Future<void> updateVoice(Voice voice) async {
    await dio.put('/voice/${voice.id}', data: {
      "name": voice.name,
      "file": voice.file,
    });
  }

  Future<void> deleteVoice(Voice voice) async {
    await dio.delete('/voice/${voice.id}');
  }
}