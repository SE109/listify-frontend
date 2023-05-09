import 'package:listify/services/app_services.dart';

import '../../models/group_task.dart';
import '../../models/respone/list_response.dart';
import '../../models/respone/single_response.dart';

class GroupTaskRepository {

  final apiService = ApiService();

  getAllGroupTasks() async {
    //get json from api
    var json = await apiService.getData('/gtask');
    //get data from json
    final value = ListResponse<GroupTask>.fromJson(
      json,
      (json) => GroupTask.fromJson(json),
    );

    return value.data;
  }

  createGroupTask(name) async {
    var body = {
      'name': name,
    };
    await apiService.postData('/gtask' , body);
  }

  updateGroupTask(id, name) async {
    var body = {
      'name': name,
    };
    await apiService.putData('/gtask/$id', body);
  }
  deleteGroupTask(id) async {
    await apiService.deleteData('/gtask/$id');
  }
}