import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://10.0.2.2:5000";
  String accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Im1haWwiOiIyMDUyMjEyMkBnbS51aXQuZWR1LnZuIn0sImlhdCI6MTY4NDI0MzI5NCwiZXhwIjoxNjg0MzI5Njk0fQ.VzrQgTtojKnD_TH7llrJTSzIKwfzG9Jtc9gGTsNePqQ';
  Future<dynamic> getData(String endpoint) async {
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
