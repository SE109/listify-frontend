class BaseResponse {
  dynamic message;
  bool? success;

  BaseResponse({this.message, this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(success: json["success"], message: json["message"]);
  }
}
