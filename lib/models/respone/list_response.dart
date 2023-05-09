import 'base_response.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListResponse<T> extends BaseResponse {
  List<T>? data;

  ListResponse({
    String? message,
    bool? success,
    this.data,
  }) : super(message: message, success: success);

  factory ListResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    var data = <T>[];
    json['data'].forEach((v) {
      data.add(create(v));
    });

    return ListResponse<T>(
        success: json["success"], message: json["message"], data: data);
  }
}

