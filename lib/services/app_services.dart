import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://10.0.2.2:5000";
  
  // String accessToken = ;
  Future<dynamic> getData(String endpoint) async {
    String? accessToken = await FlutterSecureStorage().read(key: 'accessToken');
    final response = await http.get(Uri.parse(_baseUrl + endpoint) , 
     headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<dynamic> postData(String endpoint , Object body) async {
    String? accessToken = await FlutterSecureStorage().read(key: 'accessToken');
    final response = await http.post(
      Uri.parse(_baseUrl + endpoint),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: body,
    );

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
  Future<dynamic> putData(String endpoint, Object body) async {
    String? accessToken = await FlutterSecureStorage().read(key: 'accessToken');
    final response = await http.put(
      Uri.parse(_baseUrl + endpoint),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: body,
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

   Future<dynamic> deleteData(String endpoint) async {
    String? accessToken = await FlutterSecureStorage().read(key: 'accessToken');
    final response = await http.delete(
      Uri.parse(_baseUrl + endpoint),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
